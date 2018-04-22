//
//  JSONDeserializable.swift
//  Buchhaltung
//
//  Created by Paul Neuhold on 18.02.18.
//  Copyright © 2018 Paul Neuhold. All rights reserved.
//


import Foundation

protocol JSONDesrializable {
    associatedtype Model
    static func deserialized(from json: JSONDictionary) -> Model?
}

