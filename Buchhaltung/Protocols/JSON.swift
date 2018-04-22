//
//  JSON.swift
//  Buchhaltung
//
//  Created by Paul Neuhold on 18.02.18.
//  Copyright © 2018 Paul Neuhold. All rights reserved.
//


import Foundation

public typealias JSON = Any
public typealias JSONArray = [AnyObject]
public typealias JSONDictionary = [String: AnyObject]

public protocol JSONSerializable {
    var json: JSONDictionary { get }
}

public protocol JSONDeserializable {
    init?(json: JSONDictionary?)
}

