//
//  Date+Day.swift
//  DaimoTests
//
//  Created by tskim on 17/08/2019.
//  Copyright © 2019 sogih. All rights reserved.
//

import Foundation

extension Date {
    static func day(dateString: String, locale: String = "ko_KR") -> Date {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: locale)
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: dateString)!
    }
}
