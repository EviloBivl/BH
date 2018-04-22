//
//  Accounts+CoreDataClass.swift
//  
//
//  Created by Paul Neuhold on 18.02.18.
//
//

import Foundation
import CoreData

@objc(Accounts)
public class Accounts: NSManagedObject, ManagedObjectProperty {
    
    typealias Model = Accounts
    static let tableName: String = "Accounts"
    
    class func newFromSelf() -> Accounts.Model {
        return NSEntityDescription.insertNewObject(forEntityName: Accounts.tableName, into: DataBaseController.shared.viewContext) as! Accounts
    }
    
}
