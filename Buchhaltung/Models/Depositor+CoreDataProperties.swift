//
//  Depositor+CoreDataProperties.swift
//  
//
//  Created by Paul Neuhold on 18.02.18.
//
//

import Foundation
import CoreData


extension Depositor {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Depositor> {
        return NSFetchRequest<Depositor>(entityName: "Depositor")
    }

    @NSManaged public var firstName: String?
    @NSManaged public var lastName: String?
    @NSManaged public var transaction: NSSet?

}

// MARK: Generated accessors for transaction
extension Depositor {

    @objc(addTransactionObject:)
    @NSManaged public func addToTransaction(_ value: Transaction)

    @objc(removeTransactionObject:)
    @NSManaged public func removeFromTransaction(_ value: Transaction)

    @objc(addTransaction:)
    @NSManaged public func addToTransaction(_ values: NSSet)

    @objc(removeTransaction:)
    @NSManaged public func removeFromTransaction(_ values: NSSet)

}
