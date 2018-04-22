//
//  TransactionInputViewModel.swift
//  Buchhaltung
//
//  Created by Paul Neuhold on 14.02.18.
//  Copyright © 2018 Paul Neuhold. All rights reserved.
//

import Foundation

final class TransactionInputViewModel {
    
    struct IncomeData {
        var isIncome: Bool
        var displayedText: String
    }
    
    weak var delegate: ViewModelDelegate?
    
    var transactionValueString: String? {
        didSet {
            guard let stringValue = transactionValueString,
            let doubleValue = Double(stringValue.replacingOccurrences(of: ",", with: ".")) else {
                return
            }
            transactionValue = doubleValue
        }
    }
    var transactionValue: Double?
    var transactionNumber: Int16?
    var transactionDate: Date?
    var transactionDateString: String?
    var transactionAccount: Accounts?
    var transactionJournal: Journal?
    var transactionMwSt: Taxes?
    var transactionJournalString : String?
    var isIncome: Bool? = true
    var transactionDespositor: Depositor?
    
    var accountsComboContent : [Accounts]? = []
    var accountsComboBoxStrings: [String]? = []
    var taxesComboContent: [Taxes]? = []
    var incomeComboBox: [IncomeData]? = []
    var depositorComboBoxContent: [Depositor]? = []
    var depositorComboBoxStrings: [String]? = []
    
    public init() {
    }
    
    
    func loadAccounts(){
        guard let accounts = DataBaseController.shared.getAllAccounts() else {
            return
        }
        
        accountsComboContent = accounts.sorted {acc1, acc2 in
            acc1.accountNumber < acc2.accountNumber
        }
        accountsComboBoxStrings = accountsComboContent?.flatMap {
            guard let accountText = $0.accountText, let accountGroupName = $0.accountGroupName else {
                return ""
            }
            return "\($0.accountNumber) - \(accountText) - \(accountGroupName)"
        }
    }
    
    func loadTaxes(){
        guard let taxes = DataBaseController.shared.getAllTaxes() else {
            return
        }
        
        taxesComboContent = taxes.sorted { tax1, tax2 in
            return tax1.calcFactor < tax2.calcFactor
        }
    }
    
    func loadIncomeContent() {
        let income = IncomeData(isIncome: true, displayedText: "Einnahme")
        let ausgabe = IncomeData(isIncome: false, displayedText: "Ausgabe")
        incomeComboBox?.append(income)
        incomeComboBox?.append(ausgabe)
    }
    
    func loadDepositors(){
        guard let depositors = DataBaseController.shared.getAllDepositors() else {
            return
        }
        depositorComboBoxContent = depositors.sorted {
            depositor1, depositor2 in
            guard let firstName1 = depositor1.firstName, let firstName2 = depositor2.firstName else {
                return false
            }
            return firstName1 < firstName2
        }
        
        depositorComboBoxStrings = depositorComboBoxContent?.flatMap {
            guard let firstName = $0.firstName, let lastName = $0.lastName else {
                return ""
            }
            return "\(firstName) - \(lastName)"
        }
    }
    
    var selectedDepositorIndex: Int? {
        didSet{
            guard let currentIndex = selectedDepositorIndex, let validIndex = depositorComboBoxContent?.indices.contains(currentIndex), validIndex else {
                return
            }
            transactionDespositor = depositorComboBoxContent?[currentIndex]
        }
    }
    
    var selectedIncomeIndex: Int? {
        didSet{
            guard let currentIndex = selectedIncomeIndex, let validIndex = incomeComboBox?.indices.contains(currentIndex), validIndex  else {
                return
            }
            print("\nold isIncome: \(isIncome!)")
            isIncome = incomeComboBox?[currentIndex].isIncome
            print("new isIncome: \(isIncome!)")
        }
    }
    
    var selectedAccountIndex: Int? {
        didSet{
            guard let currentIndex = selectedAccountIndex, let validIndex = accountsComboContent?.indices.contains(currentIndex), validIndex  else {
                return
            }
            transactionAccount = accountsComboContent?[currentIndex]
        }
    }
    
    var selectedTaxIndex: Int? {
        didSet {
            guard let currentIndex = selectedTaxIndex, let validIndex = taxesComboContent?.indices.contains(currentIndex), validIndex else {
                return
            }
            transactionMwSt = taxesComboContent?[currentIndex]
        }
    }
    
    var nextTransactionNumber: Int32? {
        guard let next = DataBaseController.shared.nextTransactionNumber else {
            return nil
        }
        return Int32(next)
    }
    
    var transaction: Transaction? {
        guard let value = transactionValue,
              let date = transactionDateString,
            let nsDate = date.nsDate,
            let transactionNumber = transactionNumber,
            let account = transactionAccount,
            let journalText = transactionJournalString,
            let mwSt = transactionMwSt,
            let isIncome = isIncome
        else {
            return nil
        }
        if isIncome && transactionDespositor == nil{
            return nil
        }
        let transaction = Transaction.newFromSelf()
        //Account
        transaction.account = account
        //Tax
        transaction.taxes = mwSt
        //Journal
        let journal = Journal.newFromSelf()
        journal.text = journalText
        
        //transaction Data
        transaction.journal = journal
        transaction.transactionNumber = transactionNumber
        transaction.transactionValue = value
        transaction.isIncome = isIncome
        transaction.transactionDate = nsDate
        
        return transaction
    }
    
    func accountComboBoxContent(for index: Int) -> String? {
        guard let indexPresent = accountsComboContent?.indices.contains(index), indexPresent,
            let comboBoxContent = accountsComboContent,
            let accountText = comboBoxContent[index].accountText,
            let accountGroupName = comboBoxContent[index].accountGroupName else {
              return "Something went wrong accessing ACCOUNT values"
        }
        
        return "\(comboBoxContent[index].accountNumber) - \(accountText) - \(accountGroupName)"
    }
    
    func depositorComboBoxContent(for index: Int) -> String? {
        guard let indexPresent = depositorComboBoxContent?.indices.contains(index), indexPresent,
            let comboBoxContent = depositorComboBoxContent,
            let firstName = comboBoxContent[index].firstName,
            let lastName = comboBoxContent[index].lastName else {
                return "Something went wrong accessing DEPOSITOR values"
        }
        return "\(firstName) \(lastName)"
    }
    
    func taxesComboBoxContent(for index: Int) -> String? {
        guard let indexPresent = taxesComboContent?.indices.contains(index), indexPresent,
            let comboBoxContent = taxesComboContent,
            let accountText = comboBoxContent[index].displayedText else {
                return "Something went wrong accessing TAXES values"
        }
        return accountText
    }
    
    func incomeComboBoxContent(for index: Int) -> String? {
        guard let indexPresent = incomeComboBox?.indices.contains(index), indexPresent,
            let comboBoxContent = incomeComboBox else {
                return "Something went wrong accessing INCOME values"
        }
        return comboBoxContent[index].displayedText
    }
    
    func bestMatchedTaxIndex(of string: String) -> Int? {
        guard let taxes = taxesComboContent else {
            return nil
        }
        if let index = taxes.index(where: { tax in
            guard let displayedText = tax.displayedText else {
                return false
            }
            return displayedText.starts(with: string)
        }) {
            return index
        }
        return nil
    }
    
    
    func bestMatchedIncomeIndex(of string: String) -> Int? {
        guard let income = incomeComboBox else {
            return nil
        }
        if let index = income.index(where: { income in
            return income.displayedText.lowercased().starts(with: string.lowercased())
        }) {
            return index
        }
        return nil
    }
    
    func bestMatchedAccountIndex(of string: String) -> Int? {
        guard let accounts = accountsComboContent else {
            return nil
        }
        if let index = accounts.index(where: { account in
            guard let accountText = account.accountText else {
                return false
            }
            return accountText.lowercased().starts(with: string.lowercased())
        }) { return index }
        if let index = accounts.index(where: { account in
            return String(account.accountNumber).starts(with: string)
        }){ return index }
        if let index = accounts.index(where: { account in
            guard let accountText = account.accountText else {
                return false
            }
            return accountText.lowercased().contains(string.lowercased())
        }){ return index }
        if let index = accounts.index(where: { account in
            return String(account.accountNumber).contains(string)
        }){ return index }
        return nil
    }
    
    func bestMatchedDepositorIndex(of string: String) -> Int? {
        guard let depositors = depositorComboBoxContent else {
            return nil
        }
        if let index = depositors.index(where: { depositor in
            guard let firstName = depositor.firstName else {
                return false
            }
            return firstName.lowercased().starts(with: string.lowercased())
        }) { return index }
        return nil
    }
}

