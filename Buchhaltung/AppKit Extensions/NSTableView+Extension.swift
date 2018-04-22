//
//  NSTableView+Extension.swift
//  Buchhaltung
//
//  Created by Paul Neuhold on 14.02.18.
//  Copyright © 2018 Paul Neuhold. All rights reserved.
//

import AppKit

extension NSTableView {
    
    public func register<T: XibLoadable>(xib: T.Type, bundle: Bundle? = nil) where T: NSView {
        self.register(NSNib(nibNamed: NSNib.Name(rawValue: T.xib), bundle: bundle), forIdentifier: NSUserInterfaceItemIdentifier(rawValue: T.xib))
    }
    
    public func makeView<T: XibLoadable>(xib: T.Type, owner: Any? = self) -> T?
        where T: NSView {
         return self.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: T.xib), owner: owner) as? T
    }
    
}


