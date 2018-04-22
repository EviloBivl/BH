//
//  overviewView.swift
//  Buchhaltung
//
//  Created by Paul Neuhold on 13.02.18.
//  Copyright © 2018 Paul Neuhold. All rights reserved.
//

import Foundation
import Cocoa

final class OverViewView : NSView, XibLoadable {
    static var xib: String = "OverviewView"
    
    
    @IBOutlet weak var textLabel: NSTextField!
    
}
