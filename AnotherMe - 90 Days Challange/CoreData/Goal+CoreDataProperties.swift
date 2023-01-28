//
//  Goal+CoreDataProperties.swift
//  AnotherMe - 90 Days Challange
//
//  Created by Mert Şafaktepe on 27.01.2023.
//
//

import Foundation
import CoreData


extension Goal {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Goal> {
        return NSFetchRequest<Goal>(entityName: "Goal")
    }

    @NSManaged public var isCompleted: Bool
    @NSManaged public var id: Int64
    @NSManaged public var title: String?

}

extension Goal : Identifiable {

}
