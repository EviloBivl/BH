//
//  NSViewController+Extension.swift
//  Buchhaltung
//
//  Created by Paul Neuhold on 03.03.18.
//  Copyright © 2018 Paul Neuhold. All rights reserved.
//

import AppKit

extension NSViewController {
    
    func presentAlert(message: String, additionalInfo: String, buttonText: String) {
        let alert = NSAlert()
        alert.messageText = message
        alert.informativeText = additionalInfo
        alert.addButton(withTitle: buttonText)
        alert.alertStyle = .warning
        alert.icon = nil
        alert.runModal()
    }
    
}
