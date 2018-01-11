//
//  DateFormatter.swift
//  NextAcademyFinalAssessment
//
//  Created by Obiet Panggrahito on 11/01/2018.
//  Copyright © 2018 Yohan. All rights reserved.
//

import Foundation

class DateFormatterManager {
    static let shared = DateFormatterManager()
    
    let MonthDateFormatter : DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateStyle = DateFormatter.Style.short
        formatter.dateFormat = "MMM"
        formatter.timeStyle = DateFormatter.Style.none
        return formatter
    }()
    
    let storeDateFormatter : DateFormatter = {
        let formatter = DateFormatter()
        let locale = Locale(identifier: "en_US_POSIX")
        formatter.dateStyle = DateFormatter.Style.medium
        formatter.locale = locale
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
}
