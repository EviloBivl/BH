//
//  XibLoadable.swift
//  Buchhaltung
//
//  Created by Paul Neuhold on 14.02.18.
//  Copyright © 2018 Paul Neuhold. All rights reserved.
//

import Foundation
import AppKit

public protocol XibLoadable {
    static var xib: String {get}
}
