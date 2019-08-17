//
//  File.swift
//  Daimo
//
//  Created by tskim on 17/08/2019.
//  Copyright © 2019 sogih. All rights reserved.
//

import Foundation

class DateFormatFactory {
    private static let dateFormatter = DateFormatter()
    
    static func setLocalizedDateFormatFromTemplate(_ date: Date, template: String) -> String {
        dateFormatter.setLocalizedDateFormatFromTemplate(("EEEE, MMMMd, yyyy"))
        dateFormatter.setLocalizedDateFormatFromTemplate(template)
        return dateFormatter.string(from: date)
    }
}
