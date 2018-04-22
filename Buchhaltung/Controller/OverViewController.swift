//
//  OverViewController.swift
//  Buchhaltung
//
//  Created by Paul Neuhold on 13.02.18.
//  Copyright © 2018 Paul Neuhold. All rights reserved.
//

import Foundation
import AppKit

final class OverviewController: NSViewController {
   

    
    var titles = ["Ein-/Ausgabe","BelegNr","Datum","Konto","JournalText","Betrag","MwSt"]
    
    
    var viewModel: OverviewViewModel?
    
    @IBOutlet weak var tableView: NSTableView!

    class func create(viewModel: OverviewViewModel) -> OverviewController {
        let storyBoard: NSStoryboard = NSStoryboard(name: NSStoryboard.Name(rawValue: "Overview"), bundle: nil)
        let viewController : OverviewController = storyBoard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "OverviewViewController")) as! OverviewController
        viewController.viewModel = viewModel
        return viewController
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Übersicht der Einnahmen und Ausgaben"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsColumnResizing = true
        tableView.allowsMultipleSelection = true
        tableView.rowHeight = 26
        tableView.register(xib: OverViewView.self)
        
    }
    
    @IBAction func deleteSelectedItem(_ sender: Any) {
        if tableView.selectedRow == -1 {
            let dialog = NSAlert()
            dialog.addButton(withTitle: "OK")
            dialog.messageText = "Attention..."
            dialog.informativeText = "Please select a row which you would like to delete."
            dialog.runModal()
            return
        }
        let selectedItem = tableView.selectedRow
        guard let viewModel = viewModel,
            let indexValid = viewModel.transactions?.indices.contains(selectedItem), indexValid,
            let transaction = viewModel.transactions?[selectedItem] else {
            return
        }
        
        if DataBaseController.shared.deleteManagedObject(managedObject: transaction) {
            viewModel.transactions?.remove(at: selectedItem)
            tableView.reloadData()
        }
        
    }
}

extension OverviewController : Observable {
    func notifyDataDidChange() {
        viewModel?.loadTransactions()
        tableView.reloadData()
    }
}


extension OverviewController : NSTableViewDelegate {
    
}

extension OverviewController : NSTableViewDataSource {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return viewModel?.transactions?.count ?? 0
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard
            let viewModel = viewModel,
            let transactions = viewModel.transactions,
            let indexOfColumn = titles.index(where: {
                $0 == tableColumn?.title
            }),
            let view: OverViewView = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "OverviewView"), owner: self) as? OverViewView else {
            return NSView()
        }
        
        switch indexOfColumn {
        case 0:
            view.textLabel.stringValue =  transactions[row].isIncome ? "Einnahme" : "Ausgabe"
            break
        case 1:
            view.textLabel.stringValue = "\(transactions[row].transactionNumber)"
            break
        case 2:
            let dateformatter = DateFormatter()
            dateformatter.dateFormat = "dd.MM.yyyy"
            if let date: Date = transactions[row].transactionDate as Date? {
                let dateString = dateformatter.string(from: date)
                view.textLabel.stringValue = "\(dateString)"
            }
            break
        case 3:
            view.textLabel.stringValue = "\(transactions[row].account!.accountNumber) -  \(transactions[row].account!.accountText?.prefix(10) ?? "" )"
            break
        case 4:
             view.textLabel.stringValue = "\(transactions[row].journal!.text ?? "" )"
            break
        case 5:
            view.textLabel.stringValue = "\(transactions[row].transactionValue) €"
            break
        case 6:
            if let stringValue = transactions[row].taxes?.displayedText {
                view.textLabel.stringValue = stringValue
            }
        break
        default:
            break
        }
        return view
    }

    func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
        return true
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        print("current selection \(tableView.selectedRow)")
        var selectionString: String = ""
        for index in tableView.selectedRowIndexes {
            selectionString.append(index.description)
            selectionString.append(" - ")
            
        }
        if selectionString.count > 4 {
            print(selectionString)
        }
    }
    
    
}
