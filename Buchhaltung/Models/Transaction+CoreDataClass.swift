//
//  Transaction+CoreDataClass.swift
//  
//
//  Created by Paul Neuhold on 18.02.18.
//
//

import Foundation
import CoreData

@objc(Transaction)
public class Transaction: NSManagedObject, ManagedObjectProperty {

    typealias Model = Transaction
    static let tableName: String = "Transaction"
    
    class func newFromSelf() -> Transaction.Model {
        return NSEntityDescription.insertNewObject(forEntityName: Transaction.tableName, into: DataBaseController.shared.viewContext) as! Transaction
    }
    
}
