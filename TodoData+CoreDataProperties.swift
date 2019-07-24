//
//  TodoData+CoreDataProperties.swift
//  
//
//  Created by sogih on 15/07/2019.
//
//

import Foundation
import CoreData


extension TodoData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TodoData> {
        return NSFetchRequest<TodoData>(entityName: "TodoData")
    }

    @NSManaged public var dateType: Int16
    @NSManaged public var date: NSDate?
    @NSManaged public var isDone: Bool
    @NSManaged public var todo: String?

}
