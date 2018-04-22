//
//  DepositorViewModel.swift
//  Buchhaltung
//
//  Created by Paul Neuhold on 03.03.18.
//  Copyright © 2018 Paul Neuhold. All rights reserved.
//

import Foundation

public enum DepositorColumnType : Int {
    case firstName = 0
    case lastName = 1
}

final class DepositorViewModel {
    
    var depositors: [Depositor]?
    var dbController = DataBaseController.shared
    
    public init(){
        loadDepositors()
    }
 
    func loadDepositors(){
        depositors = dbController.getAllDepositors()
    }
    
    var numberOfRows: Int? {
        return depositors?.count
    }
    
    
    func contentForCell(at row: Int, for columnType: DepositorColumnType) -> String? {
        guard let validIndex = depositors?.indices.contains(row), validIndex else {
            return nil
        }
        switch columnType {
        case .firstName:
                return depositors?[row].firstName
        case .lastName:
                return depositors?[row].lastName
        }
    }
    
}
