//
//  OverviewViewModel.swift
//  Buchhaltung
//
//  Created by Paul Neuhold on 28.02.18.
//  Copyright © 2018 Paul Neuhold. All rights reserved.
//

import Foundation

final class OverviewViewModel {
    
    var transactions: [Transaction]?
    
    
    public init(){
        loadTransactions()
    }
    
    func loadTransactions(){
        transactions = DataBaseController.shared.getAllTransactions()
    }
    
    
    
    var accounts: [Accounts]? {
        return DataBaseController.shared.getAllAccounts()
    }
    
    
}
