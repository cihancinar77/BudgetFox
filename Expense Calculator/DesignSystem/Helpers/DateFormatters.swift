//
//  DateFormatters.swift
//  Expense Calculator
//
//  Created by Cihan Cinar on 11.05.2024.
//

import Foundation

class DateFormatters {
    
    static func dateFormatToString(item: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        return dateFormatter.string(from: item)
    }
}
