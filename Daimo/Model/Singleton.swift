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

    // Review: [Refactoring] Singleton 이 가진 기능은 모호합니다.
    // 별도의 Date 관련 Class 로 제공하는 것이 좋습니다.
    
    /*
     import Foundation
     
     class DateProvider {
     static let shared = DateProvider()
     
     // UTC: 세계 표준시, GMT+9: 한국 표준시
     let startDate: Date = {
     let dateFormatter = DateFormatter()
     dateFormatter.dateFormat = "yyyy-MM-dd"
     dateFormatter.timeZone = TimeZone(abbreviation: "GMT+9")
     var date = dateFormatter.date(from: "2019-04-01")!
     return date
     }()
     */
    // UTC: 세계 표준시, GMT+9: 한국 표준시
    let startDate: Date = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+9")
        var date = dateFormatter.date(from: "2019-04-01")!
        return date
    }()

    // Review: [Refactoring] todayDate 를 Date extension 에서 제공하는 것은 어떤가요?
    /*
     extension Date {
        var todayDate: Date {
        let date = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date())!
        return date
        }
     }
     */
    let todayDate: Date = {
        let date = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date())!
        return date
    }()


    var contentOffsetCount = 0
    var currentPoint: [CGPoint] = [CGPoint(x: 0, y: 0), CGPoint(x: 0, y: 0), CGPoint(x: 0, y: 0), CGPoint(x: 0, y: 0)]
    var currentDate: [Date] = [Date(), Date(), Date(), Date()]

    var firstLoadOfSectionHeader = [false, false, false, false]
}

