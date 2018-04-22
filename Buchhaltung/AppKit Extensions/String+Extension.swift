//
//  String+Extension.swift
//  Buchhaltung
//
//  Created by Paul Neuhold on 18.02.18.
//  Copyright © 2018 Paul Neuhold. All rights reserved.
//

import Foundation

extension String {
    var date: Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "ddMMyy"
        formatter.timeZone = TimeZone(identifier: "GMT")
        return formatter.date(from: self)
    }
    
    var nsDate: NSDate? {
        return self.date as NSDate?
    }
    
}
