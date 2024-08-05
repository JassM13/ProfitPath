//
//  CSVParser.swift
//  ProfitPath
//
//  Created by Jaspreet Malak on 7/27/24.
//

import Foundation

class CSVParser {
    static func parse(fileURL: URL) -> [Trade]? {
        do {
            guard fileURL.startAccessingSecurityScopedResource() else {
                print("Failed to access security scoped resource")
                return nil
            }
            
            let data = try String(contentsOf: fileURL)
            let rows = data.components(separatedBy: "\n").filter { !$0.isEmpty }
            let header = rows.first?.components(separatedBy: ",") ?? []
            
            print("Header: \(header)")
            print("Data: \(data)")

            var trades: [Trade] = []
            
            for row in rows.dropFirst() {
                let columns = row.components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                if columns.count == header.count {
                    if let trade = parseTrade(from: columns) {
                        trades.append(trade)
                    } else {
                        print("Failed to parse trade: \(columns)")
                    }
                } else {
                    print("Column count mismatch: \(columns.count) vs \(header.count)")
                }
            }
            print("Parsed Trades: \(trades)")
            fileURL.stopAccessingSecurityScopedResource()
            return trades
        } catch {
            print("Failed to read CSV file: \(error.localizedDescription)")
            return nil
        }
    }
    
    private static func parseTrade(from columns: [String]) -> Trade? {
        guard
            let id = columns[0] as String?,
            let enteredAt = DateFormatter.dateAndTimeFormatter.date(from: columns[2]),
            let exitedAt = DateFormatter.dateAndTimeFormatter.date(from: columns[3]),
            let entryPrice = Double(columns[4]),
            let exitPrice = Double(columns[5]),
            let fees = Double(columns[6]),
            let pnl = Double(columns[7]),
            let size = Double(columns[8]),
            let type = columns[9] as String?,
            let tradeDay = DateFormatter.extractAndLocalizeDate(from: columns[10])
        else {
            return nil
        }
        
        return Trade(
            id: id,
            contractName: columns[1],
            enteredAt: enteredAt,
            exitedAt: exitedAt,
            entryPrice: entryPrice,
            exitPrice: exitPrice,
            fees: fees,
            pnl: pnl,
            size: size,
            type: type,
            tradeDay: tradeDay
        )
    }
}

extension DateFormatter {
    static let dateAndTimeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy HH:mm:ss Z"
        formatter.timeZone = TimeZone(secondsFromGMT: 0) // Use UTC
        return formatter
    }()
    
    static func extractAndLocalizeDate(from dateTimeString: String) -> Date? {
        let fullFormatter = DateFormatter()
        fullFormatter.dateFormat = "MM/dd/yyyy HH:mm:ss Z"
        fullFormatter.timeZone = TimeZone(secondsFromGMT: 0) // Parse in UTC
        
        guard let fullDate = fullFormatter.date(from: dateTimeString) else {
            print("Failed to parse date: \(dateTimeString)")
            return nil
        }
        
        // Extract the date components in UTC
        var utcCalendar = Calendar(identifier: .gregorian)
        utcCalendar.timeZone = TimeZone(secondsFromGMT: 0)!
        let dateComponents = utcCalendar.dateComponents([.year, .month, .day], from: fullDate)
        
        // Create a new date with just the date components, in the local time zone
        let localCalendar = Calendar.current
        guard let localDate = localCalendar.date(from: dateComponents) else {
            print("Failed to create local date from components")
            return nil
        }
        
        // Verify that the resulting date matches the original date string
        let originalDateString = dateTimeString.prefix(10) // "MM/dd/yyyy"
        let resultDateString = formatDateForComparison(localDate)
        
        guard originalDateString == resultDateString else {
            print("Date mismatch: original \(originalDateString), result \(resultDateString)")
            return nil
        }
        
        return localDate
    }
    
    private static func formatDateForComparison(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        formatter.timeZone = Calendar.current.timeZone
        return formatter.string(from: date)
    }
}
