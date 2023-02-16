//
//  User+CoreDataProperties.swift
//  AnotherMe - 90 Days Challange
//
//  Created by Mert Şafaktepe on 16.02.2023.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var image: Data?
    @NSManaged public var name: String?
    @NSManaged public var age: String?

}

extension User : Identifiable {

}
