//
//  CustomDateForrmatter.swift
//  GitApiTestApp
//
//  Created by Roman Rybachenko on 02.03.2020.
//  Copyright © 2020 Roman Rybachenko. All rights reserved.
//

import Foundation


class CustomDateForrmatter {
    
    enum DateFormat: String {
        case serverFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"//"yyyy-mm-dd'T'HH:MM:ssZZZZZ"
        case showHoursMinutes = "HH:mm"
        case showFullFormat = "dd.MM.yyyy, HH:mm"
    }
    
    // MARK: - Properties
    static let shared = CustomDateForrmatter()
    
    private let isoFormatter: ISO8601DateFormatter
    private let dateFormatter = DateFormatter()
    
    
    // MARK: - Init
    private init() {
        self.isoFormatter = ISO8601DateFormatter()
        self.isoFormatter.timeZone = TimeZone(abbreviation: "UTC")
        self.isoFormatter.formatOptions = [
            .withInternetDateTime,
            .withDashSeparatorInDate,
            .withColonSeparatorInTime,
            .withColonSeparatorInTimeZone
        ]
    }
    
    // MARK: - Public funcs
    
    func date(fromIsoDateString string: String?) -> Date? {
        guard let dateStr = string else { return nil }
        let date = isoFormatter.date(from: dateStr)
        return date
    }
    
    func date(from string: String?, with format: DateFormat) -> Date? {
        guard let dateStr = string else { return nil }
        dateFormatter.dateFormat = format.rawValue
        
        let date = dateFormatter.date(from: dateStr)
        return date
    }
    
    func string(from date: Date?, with format: DateFormat) -> String? {
        guard let date = date else { return nil }
        dateFormatter.dateFormat = format.rawValue
        
        return dateFormatter.string(from: date)
    }
    
}
