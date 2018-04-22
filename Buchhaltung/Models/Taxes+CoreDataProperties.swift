//
//  Taxes+CoreDataProperties.swift
//  
//
//  Created by Paul Neuhold on 18.02.18.
//
//

import Foundation
import CoreData


extension Taxes {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Taxes> {
        return NSFetchRequest<Taxes>(entityName: "Taxes")
    }

    @NSManaged public var calcFactor: Double
    @NSManaged public var displayedText: String?
    @NSManaged public var transaction: Transaction?
    @NSManaged public var createdOn: Date?

}
