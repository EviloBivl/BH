//
//  Transaction+CoreDataProperties.swift
//  
//
//  Created by Paul Neuhold on 18.02.18.
//
//

import Foundation
import CoreData


extension Transaction {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Transaction> {
        return NSFetchRequest<Transaction>(entityName: "Transaction")
    }

    @NSManaged public var isIncome: Bool
    @NSManaged public var transactionDate: NSDate?
    @NSManaged public var transactionNumber: Int16
    @NSManaged public var transactionValue: Double
    @NSManaged public var account: Accounts?
    @NSManaged public var depositor: Depositor?
    @NSManaged public var journal: Journal?
    @NSManaged public var taxes: Taxes?

}
