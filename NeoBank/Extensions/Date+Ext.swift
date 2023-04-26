//
//  Date+Ext.swift
//  NeoBank
//
//  Created by Linas Nutautas on 23/04/2023.
//

import Foundation

extension DateFormatter {
    static let customDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        return formatter
    }()
}
