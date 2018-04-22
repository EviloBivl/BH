//
//  Journal+CoreDataClass.swift
//  
//
//  Created by Paul Neuhold on 18.02.18.
//
//

import Foundation
import CoreData

@objc(Journal)
public class Journal: NSManagedObject, ManagedObjectProperty {
    
    typealias Model = Journal
    static let tableName: String = "Journal"
    
    class func newFromSelf() -> Journal.Model {
        return NSEntityDescription.insertNewObject(forEntityName: Journal.tableName, into: DataBaseController.shared.viewContext) as! Journal
    }
    
}
