//
//  TransactionInputViewController.swift
//  Buchhaltung
//
//  Created by Paul Neuhold on 14.02.18.
//  Copyright © 2018 Paul Neuhold. All rights reserved.
//

import AppKit

protocol TransactionInputDelegate: class {
    func saveData(transaction: Transaction)
    func openDepositorList()
    func openAddDepositorPopup()
}

enum TextViewTags : Int {
    case beleg = 11
    case date = 22
    case account = 33
    case journal = 44
    case betrag = 55
    case mwSt = 66
    case incomeId = 77
    case depositor = 88
    
}

final class TransactionInputViewController: NSViewController {
    
    
    @IBOutlet weak var incomeCombo: NSComboBox!
    @IBOutlet weak var textViewBelegNumber: NSTextField!
    @IBOutlet weak var textFieldDate: NSTextField!
    @IBOutlet weak var textFieldJournalText: NSTextField!
    @IBOutlet weak var textfieldBetrag: NSTextField!
    @IBOutlet weak var accountComboBox: NSComboBox!
    @IBOutlet weak var taxesComboBox: NSComboBox!
    @IBOutlet weak var depositorLabel: NSTextField!
    @IBOutlet weak var depositorComboBox: NSComboBox!
    
    
    var viewModel: TransactionInputViewModel?
    weak var delegate: TransactionInputDelegate?
    

    class func create(viewModel: TransactionInputViewModel) -> TransactionInputViewController {
        let storyBoard: NSStoryboard = NSStoryboard(name: NSStoryboard.Name(rawValue: "TransactionInput"), bundle: nil)
        let viewController: TransactionInputViewController = storyBoard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "TransactionInputController")) as! TransactionInputViewController
        viewController.viewModel = viewModel
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("\(self.description)")
        setupUI()
        
        
    }
    
    func loadComboDataSets(){
        guard let viewModel = viewModel else {
            return
        }
        viewModel.loadAccounts()
        viewModel.loadTaxes()
        viewModel.loadIncomeContent()
        viewModel.loadDepositors()
        incomeCombo.reloadData()
        taxesComboBox.reloadData()
        accountComboBox.reloadData()
        depositorComboBox.reloadData()
    }
    
    func setupUI(){
        guard let viewModel = viewModel,
            let nextTransaction = viewModel.nextTransactionNumber else {
                return
        }
        loadComboDataSets()
        
        textViewBelegNumber.intValue = nextTransaction
        textViewBelegNumber.delegate = self
        textViewBelegNumber.tag = TextViewTags.beleg.rawValue
        
        incomeCombo.usesDataSource = true
        incomeCombo.delegate = self
        incomeCombo.tag = TextViewTags.incomeId.rawValue
        incomeCombo.dataSource = self
        
        textFieldDate.delegate = self
        textFieldDate.tag = TextViewTags.date.rawValue
        
        textFieldJournalText.delegate = self
        textFieldJournalText.tag = TextViewTags.journal.rawValue
        
        textfieldBetrag.delegate = self
        textfieldBetrag.tag = TextViewTags.betrag.rawValue
        
        taxesComboBox.usesDataSource = true
        taxesComboBox.delegate = self
        taxesComboBox.dataSource = self
        taxesComboBox.tag = TextViewTags.mwSt.rawValue
        
        accountComboBox.usesDataSource = true
        accountComboBox.delegate = self
        accountComboBox.dataSource = self
        accountComboBox.tag = TextViewTags.account.rawValue
        
        depositorComboBox.usesDataSource = true
        depositorComboBox.delegate = self
        depositorComboBox.dataSource = self
        depositorComboBox.tag = TextViewTags.depositor.rawValue
    }
    
    func storeUIInputs(){
        guard let viewModel = viewModel else {
            return
        }
        viewModel.transactionNumber = Int16.init(textViewBelegNumber.intValue)
        viewModel.transactionDateString = textFieldDate.stringValue
        viewModel.selectedAccountIndex = accountComboBox.indexOfSelectedItem
        viewModel.transactionJournalString = textFieldJournalText.stringValue
        viewModel.transactionValueString = textfieldBetrag.stringValue
        viewModel.selectedTaxIndex = taxesComboBox.indexOfSelectedItem
        viewModel.selectedIncomeIndex = incomeCombo.indexOfSelectedItem
        
        
        
        //check if manual setting index of comboboxes is needed. in case of autocomplete + enter,
        //indexOfSelectedItem is net set because it was not selected
        setComboboxSelections()
        
        
    }
    
    func setComboboxSelections(){
        setIncomeComboSelection()
        setTaxesComboSelection()
        setAccountComboSelection()
        setDepositorComboSelection()
    }
    
    func setDepositorComboSelection(){
        guard let viewModel = viewModel else {
            return
        }
        if depositorComboBox.indexOfSelectedItem == -1, let currentStringValue = depositorComboBox.objectValue as! String?,
            let indexOfValue = viewModel.depositorComboBoxStrings?.index(where: {
                 $0 == currentStringValue
            }) {
            viewModel.selectedDepositorIndex = indexOfValue
            print("depositor selection NOT set")
        }
    }
    
    func setIncomeComboSelection(){
        guard let viewModel = viewModel else {
            return
        }
        if incomeCombo.indexOfSelectedItem == -1, let currentStringValue = incomeCombo.objectValue as! String?,
            let indexOfValue = viewModel.incomeComboBox?.index(where: {
                $0.displayedText == currentStringValue
            }) {
            viewModel.selectedIncomeIndex = indexOfValue
            print("income  selection NOT set")
        }
    }
    
    func setAccountComboSelection(){
        guard let viewModel = viewModel else {
            return
        }
        if accountComboBox.indexOfSelectedItem == -1, let currentStringValue = accountComboBox.objectValue as! String?,
            let indexOfValue = viewModel.accountsComboBoxStrings?.index(where: {
                $0 == currentStringValue
            }) {
            viewModel.selectedAccountIndex = indexOfValue
            print("account selection NOT set")
        }
    }
    
    func setTaxesComboSelection(){
        guard let viewModel = viewModel else {
            return
        }
        if taxesComboBox.indexOfSelectedItem == -1, let currentStringValue = taxesComboBox.objectValue as! String?,
            let indexOfValue = viewModel.taxesComboContent?.index(where: {
                $0.displayedText == currentStringValue
            }) {
            viewModel.selectedTaxIndex = indexOfValue
            print("taxes   selection NOT set")
        }
    }
}

//MARK: - Data Helper
extension TransactionInputViewController {
    func finishTransaction(){
        storeUIInputs()
        guard
            let viewModel = viewModel,
            let transaction = viewModel.transaction else {
                presentAlert(message: "Umsatz konnte nicht gespeichert werde.", additionalInfo: "Bitte alle input Felder überprüfen", buttonText: "OK")
                return
        }
        delegate?.saveData(transaction: transaction)
    }
    
    func deleteInputs(){
        viewModel = nil
        viewModel = TransactionInputViewModel()
        loadComboDataSets()
        guard let viewModel = viewModel, let nextTransactionNumber = viewModel.nextTransactionNumber else {
            return
        }
        textViewBelegNumber.intValue = nextTransactionNumber
        textFieldDate.stringValue = ""
        accountComboBox.stringValue = ""
        incomeCombo.stringValue = ""
        taxesComboBox.stringValue = ""
        textFieldJournalText.stringValue = ""
        textfieldBetrag.stringValue = ""
        //viewModel.cleanValues()
        
        
        //        viewModel.selectedTaxIndex = -1
        //        viewModel.transactionMwSt = nil
        //
        //        viewModel.selectedIncomeIndex = -1
        //        viewModel.isIncome = nil
        //
        //        viewModel.selectedAccountIndex = -1
        //        viewModel.transactionAccount = nil
        //
        //        viewModel.transactionValueString = nil
        //
        //        viewModel.transactionValueString = textfieldBetrag.stringValue
        //        viewModel.selectedTaxIndex = taxesComboBox.indexOfSelectedItem
        //        viewModel.selectedIncomeIndex = incomeCombo.indexOfSelectedItem
    }
    
    @IBAction func showAllDepositors(_ sender: Any) {
        delegate?.openDepositorList()
        print("Will start New Depositor Window")
    }
    
    @IBAction func addDepositor(_ sender: Any) {
        delegate?.openAddDepositorPopup()
    }
    
    
    func updateDepositorFields(){
        guard let viewModel = viewModel, let isIncome = viewModel.isIncome else {
            return
        }
        let hideDepositorFields = !isIncome
        depositorLabel.isHidden = hideDepositorFields
        depositorComboBox.isHidden = hideDepositorFields
        
    }
}


extension TransactionInputViewController : NSTextFieldDelegate {
    
    override func doCommand(by selector: Selector) {
        print("\(selector) - Desc: \(selector.description)")
        
    }
    
    func control(_ control: NSControl, textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
        print("control Desc: \(commandSelector.description)")
        if commandSelector == #selector(NSResponder.insertNewline(_:)) || commandSelector == #selector(NSResponder.insertTab(_:))
            || commandSelector == #selector(NSResponder.insertTab(_:)) {
            attachFirstResponder(control: control)
        }
        return false
    }
    
    
}


extension TransactionInputViewController : NSComboBoxDelegate, NSComboBoxDataSource {
    func numberOfItems(in comboBox: NSComboBox) -> Int {
        guard let inputType = TextViewTags.init(rawValue: comboBox.tag) else {
            return 0
        }
        switch inputType {
        case  .incomeId:
            return viewModel?.incomeComboBox?.count ?? 0
        case .mwSt:
            return viewModel?.taxesComboContent?.count ?? 0
        case .account:
            return viewModel?.accountsComboContent?.count ?? 0
        case .depositor:
            return viewModel?.depositorComboBoxContent?.count ?? 0
        default:
            return 0
        }
    }
    
    func comboBox(_ comboBox: NSComboBox, objectValueForItemAt index: Int) -> Any? {
        guard let inputType = TextViewTags.init(rawValue: comboBox.tag) else {
            return nil
        }
        switch inputType {
        case  .incomeId:
            return viewModel?.incomeComboBoxContent(for: index)
        case .mwSt:
            return viewModel?.taxesComboBoxContent(for: index)
        case .account:
            return viewModel?.accountComboBoxContent(for: index)
        case .depositor:
            return viewModel?.depositorComboBoxContent(for: index)
        default:
            return nil
        }
    }
    
    func comboBoxSelectionDidChange(_ notification: Notification) {
        setComboboxSelections()
        updateDepositorFields()
    }
    
    
    func comboBox(_ comboBox: NSComboBox, completedString string: String) -> String? {
        guard let inputType = TextViewTags.init(rawValue: comboBox.tag),
            let viewModel = viewModel else {
            return nil
        }
        switch inputType {
        case  .incomeId:
            if let bestMatchedIndex = viewModel.bestMatchedIncomeIndex(of: string) {
             return viewModel.incomeComboBox?[bestMatchedIndex].displayedText
            }
        case .mwSt:
            if let bestMatchedIndex = viewModel.bestMatchedTaxIndex(of: string) {
                return viewModel.taxesComboContent?[bestMatchedIndex].displayedText
            }
        case .account:
            if let bestMatchedIndex = viewModel.bestMatchedAccountIndex(of: string) {
                return viewModel.accountsComboBoxStrings?[bestMatchedIndex]
            }
        case .depositor:
            if let bestMatchedIndex = viewModel.bestMatchedDepositorIndex(of: string) {
                return viewModel.depositorComboBoxStrings?[bestMatchedIndex]
            }
        default:
            return nil
        }
        return nil
    }
    
}

//MARK: - Responder Helper
extension TransactionInputViewController: NSControlTextEditingDelegate {
    func attachFirstResponder(control: NSControl){
        guard let textViewTag = TextViewTags.init(rawValue: control.tag) else {
            return
        }
        storeCurrentValues(type: textViewTag)
        switch textViewTag {
        case .incomeId:
            textFieldDate.becomeFirstResponder()
            setIncomeComboSelection()
            updateDepositorFields()
        case .beleg:
            textFieldDate.becomeFirstResponder()
        case .date:
            accountComboBox.becomeFirstResponder()
        case .account:
            textFieldJournalText.becomeFirstResponder()
        case .journal:
            textfieldBetrag.becomeFirstResponder()
        case .betrag:
            taxesComboBox.becomeFirstResponder()
        case .mwSt:
            if let isIncome = viewModel?.isIncome, isIncome {
                depositorComboBox.becomeFirstResponder()
            } else {
                finishTransaction()
            }
        case .depositor:
            finishTransaction()
        }
    }
    
    func control(_ control: NSControl, textShouldEndEditing fieldEditor: NSText) -> Bool {
        guard let textViewTag = TextViewTags.init(rawValue: control.tag) else {
            return true
        }
        storeCurrentValues(type: textViewTag)
        return true
    }
    
    func storeCurrentValues(type: TextViewTags){
        switch type {
        case .incomeId:
            viewModel?.selectedIncomeIndex = incomeCombo.indexOfSelectedItem
        case .beleg:
            viewModel?.transactionNumber = Int16.init(textViewBelegNumber.intValue)
        case .date:
            viewModel?.transactionDateString = textFieldDate.stringValue
        case .account:
            viewModel?.selectedAccountIndex = accountComboBox.indexOfSelectedItem
        case .journal:
            viewModel?.transactionJournalString = textFieldJournalText.stringValue
        case .betrag:
            viewModel?.transactionValueString = textfieldBetrag.stringValue
        case .mwSt:
            viewModel?.selectedTaxIndex = taxesComboBox.indexOfSelectedItem
        case .depositor:
            viewModel?.selectedDepositorIndex = depositorComboBox.indexOfSelectedItem
        }
    }
}

extension TransactionInputViewController : StartViewControllerDelegate {
    func didPressSave() {
        finishTransaction()
    }
    
    func didSaveSuccessFully() {
        deleteInputs()
    }
}

extension TransactionInputViewController : Observable {
    func notifyDataDidChange() {
        loadComboDataSets()
    }
}









