//
//  Person+CoreDataProperties.swift
//  HitList
//
//  Created by Paweł Liczmański on 05.09.2017.
//  Copyright © 2017 Xavi Moll. All rights reserved.
//

import Foundation
import CoreData


extension Person {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Person> {
        return NSFetchRequest<Person>(entityName: "Person")
    }

    @NSManaged public var name: String?

}
