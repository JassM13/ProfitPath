//
//  JournalView.swift
//  ProfitPath
//
//  Created by Jaspreet Malak on 3/23/24.
//

import SwiftUI

struct JournalView: View {
    let currentDate = Date()
    let calendar = Calendar.current
    @State private var selectedMonth = Date()
    @State private var selectedDate: Date? = nil
    
    let profitData: [Date: Double] = [
        // Sample data - replace with your actual data
        Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 20))!: 100.0,
        Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21))!: -50.0,
        Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 22))!: 75.0,
        // Add more dates and profit/loss values as needed
    ]
    
    var body: some View {
        VStack {
            daysOfWeek
            daysGrid
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
            Spacer()
        }
        .padding()
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
                if let date = date {
                    dayView(for: date)
                        .onTapGesture {
                            selectedDate = date
                        }
                } else {
                    Color.clear
                        .frame(height: 60)
                }
            }
        }
    }
    
    func dayView(for date: Date) -> some View {
        let isToday = calendar.isDate(date, inSameDayAs: currentDate)
        let isSelected = selectedDate != nil && calendar.isDate(date, inSameDayAs: selectedDate!)
        let profit = profitData[date]
        let isCurrentMonth = calendar.isDate(date, equalTo: selectedMonth, toGranularity: .month)
        let isWeekend = calendar.isDateInWeekend(date)
        
        return VStack(alignment: .leading) {
            Text("\(calendar.component(.day, from: date))")
                .font(.caption)
                .fontWeight(isToday ? .bold : .regular)
                .foregroundColor(isSelected ? .white : (isWeekend ? .gray : isCurrentMonth ? .primary : .gray))
                .padding(.top, 4)
                .padding(.leading, 4)
            Spacer()
            if let profit = profit {
                Text(String(format: "%.2f", profit))
                    .font(.caption2)
                    .foregroundColor(profit >= 0 ? .green : .red)
                    .padding(.bottom, 4)
                    .padding(.leading, 4)
            }
        }
        .frame(height: 60)
        .frame(maxWidth: .infinity)  // Ensuring full width
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(dayBackgroundColor(for: date, profit: profit, isSelected: isSelected))
        )
    }
    
    func dayBackgroundColor(for date: Date, profit: Double?, isSelected: Bool) -> Color {
        if isSelected {
            return .blue
        } else if calendar.isDate(date, inSameDayAs: currentDate) {
            return .blue.opacity(0.3)
        } else if let profit = profit {
            return profit >= 0 ? .green.opacity(0.1) : .red.opacity(0.1)
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
}

#Preview {
    JournalView()
}
