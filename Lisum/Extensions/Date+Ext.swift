//
//  Date+Ext.swift
//  Lisum
//
//  Created by Terry Kuo on 2023/4/3.
//

import Foundation

extension Date {
    func convertToYearMonthDatFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        return dateFormatter.string(from: self)
    }
}
