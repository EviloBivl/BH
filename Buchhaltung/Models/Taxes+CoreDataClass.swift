//
//  Taxes+CoreDataClass.swift
//  
//
//  Created by Paul Neuhold on 18.02.18.
//
//

import Foundation
import CoreData

@objc(Taxes)
public class Taxes: NSManagedObject, ManagedObjectProperty {
    
    typealias Model = Taxes
    static let tableName: String = "Taxes"
    
    class func newFromSelf() -> Taxes.Model {
        return NSEntityDescription.insertNewObject(forEntityName: Taxes.tableName, into: DataBaseController.shared.viewContext) as! Taxes
    }
    
}
