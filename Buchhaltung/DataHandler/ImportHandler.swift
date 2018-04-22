
//  ImportHandler.swift
//  Buchhaltung
//
//  Created by Paul Neuhold on 18.02.18.
//  Copyright © 2018 Paul Neuhold. All rights reserved.
//

import Foundation

class ImportHandler {
    static let shared = ImportHandler()
    private init () {}

    
    func readJsonFile(fileName: String) -> JSONDictionary? {
        if let path = Bundle.main.path(forResource: fileName, ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as? JSONDictionary
                return jsonResult

            } catch {
                print("Error while loading Accounts into Memory \(error)")
                // handle error
            }
        }
        return nil
    }
    
    
}







