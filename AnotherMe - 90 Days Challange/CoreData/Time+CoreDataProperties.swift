//
//  Time+CoreDataProperties.swift
//  AnotherMe - 90 Days Challange
//
//  Created by Mert Şafaktepe on 27.01.2023.
//
//

import Foundation
import CoreData


extension Time {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Time> {
        return NSFetchRequest<Time>(entityName: "Time")
    }

    @NSManaged public var startDate: Date?

}

extension Time : Identifiable {

}
