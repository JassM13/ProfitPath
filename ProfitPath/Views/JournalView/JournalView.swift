//
//  JournalView.swift
//  ProfitPath
//
//  Created by Jaspreet Malak on 3/23/24.
//

import SwiftUI

struct JournalView: View {
    @StateObject private var accountManager = AccountManager.shared
    
    let currentDate = Date()
    let calendar = Calendar.current
    @State private var selectedMonth = Date()
    @State private var selectedDate: Date? = nil
    
    var body: some View {
        VStack(spacing: 10) {
            ScrollView {
                monthLabel
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading)
                VStack {
                    daysOfWeek
                        .padding(.vertical)
                    daysGrid
                }
                .padding(10)
                .background(Color.white.opacity(0.05), in: .rect(cornerRadius: 20))
                .gesture(
                    DragGesture()
                        .onEnded { value in
                            if value.translation.width < -50 {
                                selectedMonth = calendar.date(byAdding: .month, value: 1, to: selectedMonth)!
                            } else if value.translation.width > 50 {
                                selectedMonth = calendar.date(byAdding: .month, value: -1, to: selectedMonth)!
                            }
                        }
                )
                
                if let selectedDate = selectedDate {
                    tradesForSelectedDateView(date: selectedDate)
                }
                
                Spacer()
            }
        }
        .padding(.horizontal)
    }
    
    var daysOfWeek: some View {
        HStack {
            ForEach(["S", "M", "T", "W", "T", "F", "S"], id: \.self) { day in
                Text(day)
                    .fontWeight(.bold)
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity)
            }
        }
    }
    
    var daysGrid: some View {
        let days = daysInMonth(for: selectedMonth)
        return LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 8) {
            ForEach(days, id: \.self) { date in
                dayView(for: date)
            }
        }
    }
    
    var monthLabel: some View {
        let dateFormatter = DateFormatter()
        
        // Check if a date is selected
        if let selectedDate = selectedDate {
            dateFormatter.dateFormat = "MMMM d, yyyy"
            let monthDateString = dateFormatter.string(from: selectedDate)
            return Text(monthDateString)
                .font(.title)
                .fontWeight(.bold)
        } else {
            dateFormatter.dateFormat = "MMMM yyyy"
            let monthString = dateFormatter.string(from: selectedMonth)
            return Text(monthString)
                .font(.title)
                .fontWeight(.bold)
        }
    }

    
    func dayView(for date: Date?) -> some View {
        guard let date = date else {
            return AnyView(Color.clear.frame(height: 60))
        }
        
        let isSelected = selectedDate != nil && calendar.isDate(date, inSameDayAs: selectedDate!)
        let trades = tradesForDate(date)
        let profit = trades.reduce(0) { $0 + $1.pnl }
        let isCurrentMonth = calendar.isDate(date, equalTo: selectedMonth, toGranularity: .month)
        let isWeekend = calendar.isDateInWeekend(date)
        
        return AnyView(
            Button(action: {
                selectedDate = date
            }) {
                VStack {
                    Text("\(calendar.component(.day, from: date))")
                        .font(.caption)
                        .foregroundColor(isSelected ? .white : (isWeekend ? .gray : isCurrentMonth ? .primary : .gray))
                        .padding(.top, 4)
                    Spacer()
                    if !trades.isEmpty {
                        Text(String(format: "%.2f", profit))
                            .lineLimit(1)
                            .font(.caption2)
                            .foregroundColor(profit >= 0 ? .accentColor : .red)
                            .padding(.bottom, 4)
                    }
                }
                .frame(height: 60)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(dayBackgroundColor(for: date, profit: profit, isSelected: isSelected))
                )
            }
        )
    }
    
    func tradesForSelectedDateView(date: Date) -> some View {
        let trades = tradesForDate(date)
        
        return VStack(spacing: 12) {
            ForEach(trades) { trade in
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text(trade.contractName)
                            .font(.headline)
                        Spacer()
                        TradeTypeBadge(type: trade.type)
                    }
                    
                    TradeInfoRow(title: "Entered", value: formattedTime(trade.enteredAt))
                    TradeInfoRow(title: "Exited", value: formattedTime(trade.exitedAt))
                    TradeInfoRow(title: "Entry Price", value: formattedPrice(trade.entryPrice))
                    TradeInfoRow(title: "Exit Price", value: formattedPrice(trade.exitPrice))
                    TradeInfoRow(title: "Size", value: formattedDecimal(trade.size))
                    TradeInfoRow(title: "Fees", value: formattedPrice(trade.fees))
                    
                    HStack {
                        PnLView(pnl: trade.pnl)
                        Spacer()
                        Text("Trade Day: \(formattedDate(trade.tradeDay))")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(10)
            }
        }
    }
    
    func tradesForDate(_ date: Date) -> [Trade] {
        let calendar = Calendar.current
        return accountManager.selectedAccount.trades.filter { calendar.isDate($0.tradeDay, inSameDayAs: date) }
    }
    
    func dayBackgroundColor(for date: Date, profit: Double, isSelected: Bool) -> Color {
        if isSelected {
            // Increase opacity for the selected date
            if profit < 0 {
                return .red.opacity(0.3) // Higher opacity for selected negative profit days
            } else {
                return .accentColor.opacity(0.6) // Higher opacity for selected non-negative days
            }
        } else if calendar.isDate(date, inSameDayAs: currentDate) {
            return .accentColor.opacity(0.3) // Lower opacity for the current date
        } else if profit < 0 {
            return .red.opacity(0.1) // Default opacity for negative profit days
        } else if profit != 0 {
            return profit >= 0 ? .accentColor.opacity(0.1) : .clear // Default opacity for other non-negative profit days
        } else {
            return .clear
        }
    }
    
    func daysInMonth(for date: Date) -> [Date?] {
        guard let range = calendar.range(of: .day, in: .month, for: date),
              let firstDay = calendar.date(from: calendar.dateComponents([.year, .month], from: date)) else {
            return []
        }
        
        let dayCount = range.count
        let firstWeekday = calendar.component(.weekday, from: firstDay)
        let previousMonthDays = firstWeekday - 1
        let nextMonthDays = 7 - (dayCount + previousMonthDays) % 7
        
        var days: [Date?] = []
        
        // Previous month's dates
        if previousMonthDays > 0 {
            let previousMonth = calendar.date(byAdding: .month, value: -1, to: firstDay)!
            let previousMonthRange = calendar.range(of: .day, in: .month, for: previousMonth)!
            let previousMonthDayCount = previousMonthRange.count
            
            days += (previousMonthDayCount - previousMonthDays + 1...previousMonthDayCount).map { day -> Date in
                calendar.date(byAdding: .day, value: day - 1, to: previousMonth)!
            }
        }
        
        // Current month's dates
        days += (1...dayCount).map { day -> Date in
            calendar.date(byAdding: .day, value: day - 1, to: firstDay)!
        }
        
        // Next month's dates
        if nextMonthDays < 7 {
            let nextMonth = calendar.date(byAdding: .month, value: 1, to: firstDay)!
            days += (1...nextMonthDays).map { day -> Date in
                calendar.date(byAdding: .day, value: day - 1, to: nextMonth)!
            }
        }
        
        return days
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
    
    private func formattedTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    func formattedPrice(_ price: Double) -> String {
        return String(format: "%.2f", price)
    }
    
    func formattedDecimal(_ value: Double) -> String {
        return String(format: "%.0f", value)
    }
}

#Preview {
    JournalView()
}
