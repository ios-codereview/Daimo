//
//  DateFormatFactoryTest.swift
//  DaimoTests
//
//  Created by tskim on 17/08/2019.
//  Copyright © 2019 sogih. All rights reserved.
//

import Foundation
import XCTest
@testable import Daimo

class DateFormatFactoryTest: XCTestCase {
    func testSetLocalizedDateFormatFromTemplate() {
        let sDate = Date.day(dateString: "2019-01-01")
        XCTAssertEqual(DateFormatFactory.setLocalizedDateFormatFromTemplate(sDate, template: "EEEE, MMMMd, yyyy"), "Tuesday, January 1, 2019")
        XCTAssertEqual(DateFormatFactory.setLocalizedDateFormatFromTemplate(sDate, template: "yyyy"), "2019")
        XCTAssertEqual(DateFormatFactory.setLocalizedDateFormatFromTemplate(sDate, template: "MMMM, yyyy"), "January 2019")
        XCTAssertEqual(DateFormatFactory.setLocalizedDateFormatFromTemplate(sDate, template: "EE, MMMd, yyyy"), "Tue, Jan 1, 2019")
        XCTAssertEqual(DateFormatFactory.setLocalizedDateFormatFromTemplate(sDate, template: "EE, MMMd"), "Tue, Jan 1")
        
    }
}
