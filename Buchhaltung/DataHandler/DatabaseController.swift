//
//  DatabaseController.swift
//  Buchhaltung
//
//  Created by Paul Neuhold on 11.02.18.
//  Copyright © 2018 Paul Neuhold. All rights reserved.
//

import Foundation
import CoreData
import Cocoa

class DataBaseController {
    
    static let shared = DataBaseController()
    private init() {}
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "Buchhaltung")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error)")
            }
        })
        return container
    }()
    
    public var countOfTransaction : Int? {
        do {
            let fetchRequest : NSFetchRequest<Transaction> = Transaction.fetchRequest()
            let transactions = try viewContext.fetch(fetchRequest)
            return transactions.count
        } catch {
            print("Error: Could not get Countr of Transactions =>  \(error)")
            return nil
        }
    }
    
    public var nextTransactionNumber: Int16? {
        do {
            let fetchRequest : NSFetchRequest<Transaction> = Transaction.fetchRequest()
            let transactions = try viewContext.fetch(fetchRequest)
            
            guard let lastTransactionNumber = transactions.last?.transactionNumber else {
                if transactions.count == 0 {
                    return 1
                } else {
                    return nil
                }
            }
            return lastTransactionNumber + 1
            
        } catch {
            print("Error: Could not get next Transaction Number =>  \(error)")
            return nil
        }
        
    }

    func getAllTransactions() -> [Transaction]? {
        do {
            return try viewContext.fetch(Transaction.fetchRequest())
        } catch {
            print("Error: Could not get all Transactions =>  \(error)")
            return nil
        }
    }
    
    func getAllAccounts() -> [Accounts]? {
        do {
            let fetchRequest: NSFetchRequest<Accounts> = Accounts.fetchRequest()
            return try viewContext.fetch(fetchRequest)
        } catch {
            print("Error: Could not get all Transactions =>  \(error)")
            return nil
        }
    }
    
    func getAllDepositors() -> [Depositor]? {
        do {
            let fetchRequest: NSFetchRequest<Depositor> = Depositor.fetchRequest()
            return try viewContext.fetch(fetchRequest)
        } catch {
            print("Error: Could not get all Depositors")
            return nil
        }
    }
    
    func getAllTaxes() -> [Taxes]? {
        do {
            let fetchTaxes : NSFetchRequest<Taxes> = Taxes.fetchRequest()
            return try viewContext.fetch(fetchTaxes)
        } catch {
            print("Error: Could not get all Taxes => \(error)")
            return nil
        }
    }
    
    func deleteAllTransactions() {
        guard let transactions = getAllTransactions() else {
            return
        }
        for transaction in transactions {
            viewContext.delete(transaction)
        }
        let _ = saveAndReturnQuitStatus()
    }
    
    func deleteAllAccounts(){
        guard let accounts = getAllAccounts() else {
            return
        }
        for account in accounts {
            viewContext.delete(account)
        }
        let _ = saveAndReturnQuitStatus()
    }
    func deleteAllTaxes(){
        guard let taxes = getAllTaxes() else {
            return
        }
        for tax in taxes {
            viewContext.delete(tax)
        }
        let _ = saveAndReturnQuitStatus()
    }
    
    func deleteAllRecentAccounts(){
        guard let accounts = getAllAccounts() else {
            return
        }
        for account in accounts {
            viewContext.delete(account)
        }
        let _ = saveAndReturnQuitStatus()
    }
    
    func deleteAllData(){
        deleteAllTaxes()
        deleteAllAccounts()
        deleteAllTransactions()
    }
    
    func getTransactionWithValueGreaterThan(value: Int) -> [Transaction]? {
        let predicate = NSPredicate(format: "transactionValue > \(value)")
        return getTransactionsWithPredicate(predicate: predicate)
    }
    
    func getTransactionsWithPredicate(predicate: NSPredicate) -> [Transaction]? {
        do {
            let fetchRequest : NSFetchRequest<Transaction> = Transaction.fetchRequest()
            fetchRequest.predicate = predicate
            let transactions = try viewContext.fetch(fetchRequest)
            return transactions
            
        } catch {
            print("Error: Could not get next Transaction Number =>  \(error)")
            return nil
        }
        
    }
    
    func getAllTransactionFromAccountWithPredicate(predicate: NSPredicate) -> NSSet? {
        do {
            let fetchRequest : NSFetchRequest<Accounts> = Accounts.fetchRequest()
            fetchRequest.predicate = predicate
            let transactionsFromAccount: [Accounts] = try viewContext.fetch(fetchRequest)
            return transactionsFromAccount[0].transaction
        } catch {
            print("Error while get all Transactions from Account: \(error)")
            return nil
        }
    }
    
    func deleteManagedObject(managedObject: NSManagedObject) -> Bool {
        viewContext.delete(managedObject)
        if saveAndReturnQuitStatus() != .terminateNow {
            print("Error while deleting ManagedObject")
            return false
        }
        return true
    }
    
    func loadTaxesIntoData(){
        guard let json = ImportHandler.shared.readJsonFile(fileName: "jsonTaxes"),
            let jsonArray = json["Taxes"] as? JSONArray else {
                return
        }
        if let existingTaxes = getAllTaxes(), existingTaxes.count > 0 {
            print("Taxes already loaded")
            return
        }
        
        print("Will load Taxes into Memory")
        var allTaxes: [Taxes] = []
        for account in jsonArray {
            if let acc = account as? JSONDictionary {
                if  let calcFactor = acc["CalculationFactor"] as? Double,
                    let displayedText = acc["DisplayedText"] as? String {
                    let aTax = Taxes.newFromSelf()
                    aTax.calcFactor = calcFactor
                    aTax.displayedText = displayedText
                    allTaxes.append(aTax)
                }
            }
        }
        print("Will Store \(allTaxes.count) Taxes to Core Data")
        if saveAndReturnQuitStatus() != .terminateNow {
            print("Error: Could not store taxes to Core Data")
        }
        
    }
    
    func loadDepositorsIntoData(){
        
    }
    
    func loadAccountsIntoMemory(){
        if let existingAccounts = getAllAccounts(),
            existingAccounts.count > 0 {
            print("Accounts already loaded")
            return
        }
        guard let json = ImportHandler.shared.readJsonFile(fileName: "jsonAccounts"),
            let jsonArray = json["Accounts"] as? JSONArray else {
                return
        }
        
        print("Will load Accounts into Memory")
        var allAccounts:[Accounts] = []
        for account in jsonArray {
            if let acc = account as? JSONDictionary {
                if  let accountNumber = acc["KtoNr"] as? Int16,
                    let accountText = acc["Kontotext"] as? String,
                    let accountGroupId = acc["KontogruppeId"] as? String {
                    let anAccount = Accounts.newFromSelf()
                    anAccount.accountText = accountText
                    anAccount.accountNumber = accountNumber
                    anAccount.accountGroupName = accountGroupId
                    allAccounts.append(anAccount)
                }
            }
        }
        print("Will Store \(allAccounts.count) Accounts to Core Data")
        if saveAndReturnQuitStatus() != .terminateNow {
            print("Error: Could not Store Accounts to Core Data")
        }
    }
    
    func saveAndReturnQuitStatus() -> NSApplication.TerminateReply {
        
        if !viewContext.commitEditing() {
            NSLog("\(NSStringFromClass(type(of: self))) unable to commit editing to terminate")
            return .terminateCancel
        }
        
        if !viewContext.hasChanges {
            return .terminateNow
        }
        
        do {
            try viewContext.save()
        } catch {
            let nserror = error as NSError
            
            // Customize this code block to include application-specific recovery steps.
            let sender = NSApplication.shared
            let result = sender.presentError(nserror)
            if (result) {
                return .terminateCancel
            }
            
            let question = NSLocalizedString("Could not save changes while quitting. Quit anyway?", comment: "Quit without saves error question message")
            let info = NSLocalizedString("Quitting now will lose any changes you have made since the last successful save", comment: "Quit without saves error question info");
            let quitButton = NSLocalizedString("Quit anyway", comment: "Quit anyway button title")
            let cancelButton = NSLocalizedString("Cancel", comment: "Cancel button title")
            let alert = NSAlert()
            alert.messageText = question
            alert.informativeText = info
            alert.addButton(withTitle: quitButton)
            alert.addButton(withTitle: cancelButton)
            
            let answer = alert.runModal()
            if answer == NSApplication.ModalResponse.alertSecondButtonReturn {
                return .terminateCancel
            }
        }
        // If we got here, it is time to quit.
        return .terminateNow
    } 
    
}
