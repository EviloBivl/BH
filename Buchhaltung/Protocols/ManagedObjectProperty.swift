//
//  NSManagedObjectProperty.swift
//  Buchhaltung
//
//  Created by Paul Neuhold on 11.02.18.
//  Copyright © 2018 Paul Neuhold. All rights reserved.
//

import Foundation

protocol ManagedObjectProperty {
    associatedtype Model
    static var tableName: String {get}
    static func newFromSelf() -> Model
}
