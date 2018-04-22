//
//  Accounts+CoreDataProperties.swift
//  
//
//  Created by Paul Neuhold on 18.02.18.
//
//

import Foundation
import CoreData


extension Accounts {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Accounts> {
        return NSFetchRequest<Accounts>(entityName: "Accounts")
    }

    @NSManaged public var accountGroupId: Int16
    @NSManaged public var accountGroupName: String?
    @NSManaged public var accountId: Int16
    @NSManaged public var accountNumber: Int16
    @NSManaged public var accountText: String?
    @NSManaged public var transaction: NSSet?
    
    public enum Keys: String {
        case accountGroupId = "accountGroupId"
        case accountGroupName = "accountGroupName"
        case accountId = "accountId"
        case accountNumber = "accountNumber"
        case accountText = "accountText"
        case transactionSet = "transaction"
    }

}

// MARK: Generated accessors for transaction
extension Accounts {

    @objc(addTransactionObject:)
    @NSManaged public func addToTransaction(_ value: Transaction)

    @objc(removeTransactionObject:)
    @NSManaged public func removeFromTransaction(_ value: Transaction)

    @objc(addTransaction:)
    @NSManaged public func addToTransaction(_ values: NSSet)

    @objc(removeTransaction:)
    @NSManaged public func removeFromTransaction(_ values: NSSet)

}
