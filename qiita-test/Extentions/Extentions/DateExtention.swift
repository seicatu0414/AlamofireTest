//
//  DateExtention.swift
//  qiita-test
//
//  Created by yamaguchi kohei on 2024/11/07.
//

import Foundation

extension Date {
    // "yyyy/MM/dd"
    func dateToString(date: Date, format: String) -> String {
        let formatter: DateFormatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
}
