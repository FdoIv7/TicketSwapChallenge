//
//  Utilities.swift
//  TicketSwapChallenge
//
//  Created by Fernando Ives on 26/07/22.
//

import Foundation

class Utilities {
    static func getColor(_ value: Int) -> Double {
        return Double(value) / Double(255)
    }

    static func getYear(for date: String) -> Int? {
        let dateFormatterGet = DateFormatter()
        let date = dateFormatterGet.date(from: date)
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year], from: date ?? Date())
        dateFormatterGet.dateFormat = "yyyy-MM-dd"
        return components.year
    }

}
