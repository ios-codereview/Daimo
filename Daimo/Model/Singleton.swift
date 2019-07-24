//
//  Singleton.swift
//  Daimo
//
//  Created by sogih on 15/07/2019.
//  Copyright © 2019 sogih. All rights reserved.
//

import Foundation
import UIKit

class Singleton {
    
    static let shared = Singleton()
    
    let startDate: Date = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        var date = Date()
        date = dateFormatter.date(from: "2018-12-31")!
        return date
    }()
    
    let todayDate = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date())!
    
    
    var contentOffsetCount = 0
    var currentPoint: [CGPoint] = [CGPoint(x: 0, y: 0), CGPoint(x: 0, y: 0), CGPoint(x: 0, y: 0), CGPoint(x: 0, y: 0)]
    var currentDate: [Date] = [Date(), Date(), Date(), Date()]
    
    var firstLoadOfSectionHeader = [false, false, false, false]
}
