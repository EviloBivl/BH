//
//  Depositor+CoreDataClass.swift
//  
//
//  Created by Paul Neuhold on 18.02.18.
//
//

import Foundation
import CoreData

@objc(Depositor)
public class Depositor: NSManagedObject, ManagedObjectProperty {
    
    typealias Model = Depositor
    static let tableName: String = "Depositor"
    
    class func newFromSelf() -> Depositor.Model {
        return NSEntityDescription.insertNewObject(forEntityName: Depositor.tableName, into: DataBaseController.shared.viewContext) as! Depositor
    }
    
}
