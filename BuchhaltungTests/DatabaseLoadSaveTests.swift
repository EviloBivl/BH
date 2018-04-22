//
//  DatabaseLoadSaveTests.swift
//  BuchhaltungTests
//
//  Created by Paul Neuhold on 16.02.18.
//  Copyright © 2018 Paul Neuhold. All rights reserved.
//

import XCTest
@testable import Buchhaltung

class DatabaseLoadSaveTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

    func testSimpleDataAccess(){
        let databaseController = DataBaseController.shared
        XCTAssert(databaseController.persistentContainer.name.elementsEqual("Buchhaltung"))
        
    }
    
    func testSaveAndDeleteTransaction(){
        do {
            let dataBaseController = DataBaseController.shared
            var currentDatasets = 0
            
            let fetchResult: NSFetchRequest<Transaction> = Transaction.fetchRequest()
            var invoices = try DataBaseController.shared.viewContext.fetch(fetchResult)
            currentDatasets = invoices.count
            
            let _ = Transaction.newFromSelf()
            XCTAssert(dataBaseController.saveAndReturnQuitStatus() == .terminateNow)
            invoices = try DataBaseController.shared.viewContext.fetch(fetchResult)
            
            XCTAssertEqual(invoices.count, (currentDatasets + 1) )
            for invoice in invoices {
                dataBaseController.viewContext.delete(invoice)
            }
            XCTAssert(dataBaseController.saveAndReturnQuitStatus() == .terminateNow)
            invoices = try DataBaseController.shared.viewContext.fetch(fetchResult)
            XCTAssertEqual(invoices.count, 0 )
            
            
        } catch {
            print("Error fetching Database infos")
        }
    }
    
    func testNextTransactionNumber() {
        let transaction = Transaction.newFromSelf()
        transaction.transactionNumber = 1337
        XCTAssert(DataBaseController.shared.saveAndReturnQuitStatus() == .terminateNow)
        XCTAssertEqual(DataBaseController.shared.nextTransactionNumber, 1338)
    }
    
    func testGreaterThanPredicate() {
        DataBaseController.shared.deleteAllTransactions()
        if let allTransactions = DataBaseController.shared.getAllTransactions() {
            XCTAssertEqual(allTransactions.count, 0)
        }
        let transaction = Transaction.newFromSelf()
        transaction.transactionValue = 100
        
        let anotherTransaction = Transaction.newFromSelf()
        anotherTransaction.transactionValue = 120
        
        XCTAssert(DataBaseController.shared.saveAndReturnQuitStatus() == .terminateNow)
        if let foundTransactions = DataBaseController.shared.getTransactionWithValueGreaterThan(value: 99) {
            XCTAssertEqual(foundTransactions.count, 2)
        }
        if let foundTransactions = DataBaseController.shared.getTransactionWithValueGreaterThan(value: 100) {
            XCTAssertEqual(foundTransactions.count, 1)
        }
        if let foundTransactions = DataBaseController.shared.getTransactionWithValueGreaterThan(value: 110) {
            XCTAssertEqual(foundTransactions.count, 1)
        }
        if let foundTransactions = DataBaseController.shared.getTransactionWithValueGreaterThan(value: 120) {
            XCTAssertEqual(foundTransactions.count, 0)
        }
    }
    
    func testGetTransactionsWithAccountNumber(){
        DataBaseController.shared.deleteAllData()
        if let allTransactions = DataBaseController.shared.getAllTransactions() {
            XCTAssertEqual(allTransactions.count, 0)
        }
        let account: Accounts = Accounts.newFromSelf()
        account.accountNumber = 4222
        account.accountText = "Honorare 20%"
        var transaction : [Transaction] = []
        transaction.append(Transaction.newFromSelf())
        transaction.append(Transaction.newFromSelf())
        transaction.append(Transaction.newFromSelf())
        
        
        for trans in transaction {
            trans.account = account
        }
        transaction.append(Transaction.newFromSelf())
        let account2 = Accounts.newFromSelf()
        account2.accountNumber = 4100
        account2.accountText = "Nothing important"
        transaction[3].account = account2
        
        XCTAssert(DataBaseController.shared.saveAndReturnQuitStatus() == .terminateNow)
        let perdicate: NSPredicate = NSPredicate(format: "account.accountNumber = 4222")
        if let foundTransactions = DataBaseController.shared.getTransactionsWithPredicate(predicate: perdicate) {
             XCTAssertEqual(foundTransactions.count, 3)
        }
        
        let perdicate2: NSPredicate = NSPredicate(format: "account.accountNumber > 4050")
        if let foundTransactions = DataBaseController.shared.getTransactionsWithPredicate(predicate: perdicate2) {
            XCTAssertEqual(foundTransactions.count, 4)
        }
        
        if let transactionSet = DataBaseController.shared.getAllTransactionFromAccountWithPredicate(
            predicate: NSPredicate(format: "accountNumber = 4222")) {
            let transactions: [Transaction]? = transactionSet.allObjects as? [Transaction]
            XCTAssertEqual(transactions?.count ?? 0, 3)
            
        }
    }
    
}






















