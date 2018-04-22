//
//  DepositorCreationViewModel.swift
//  Buchhaltung
//
//  Created by Paul Neuhold on 03.03.18.
//  Copyright © 2018 Paul Neuhold. All rights reserved.
//

import Foundation

final class DepositorCreationViewModel {
    
    
    var firstName : String?
    var lastName : String?
    
    public init(){
            
    }
    
    func createDepositorAndSave() -> Bool {
        guard let firstName = firstName, let lastName = lastName else {
            return false
        }
        let depositor = Depositor.newFromSelf()
        depositor.firstName = firstName
        depositor.lastName = lastName
        if DataBaseController.shared.saveAndReturnQuitStatus() == .terminateNow {
            return true
        }
        return false
    }
    
    
}
