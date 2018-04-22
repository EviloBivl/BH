//
//  DepositorController.swift
//  Buchhaltung
//
//  Created by Paul Neuhold on 03.03.18.
//  Copyright © 2018 Paul Neuhold. All rights reserved.
//

import Cocoa

protocol DepositorDelegate : class {
    func didSaveDepositorFromList()
}

class DepositorViewController: NSViewController {

    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var titleLabel: NSTextField!
    
    weak var delegate : DepositorDelegate?
    
    var viewModel: DepositorViewModel?
    
    class func create(viewModel: DepositorViewModel) -> DepositorViewController {
        let storyBoard: NSStoryboard = NSStoryboard(name: NSStoryboard.Name(rawValue: "Depositor"), bundle: nil)
        let controller: DepositorViewController = storyBoard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "DepositorViewController")) as! DepositorViewController
        controller.viewModel = viewModel
        return controller
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    
    func configureTableHeaderColumns(){
        for i in 0..<tableView.tableColumns.count {
            tableView.tableColumns[i].headerCell.tag = i
        }
    }
    
    func setup(){
        if viewModel == nil {
            viewModel = DepositorViewModel()
        }
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsColumnResizing = true
        tableView.allowsMultipleSelection = true
        tableView.rowHeight = 26
        tableView.register(xib: OverViewView.self)
        configureTableHeaderColumns()
    }
    
    @IBAction func createNewDepositor(_ sender: NSButton) {
        let controller = DepositorCreationViewController.create(viewModel: DepositorCreationViewModel())
        controller.delegate = self
        presentViewControllerAsSheet(controller)
    }

    func didUpdate(){
        viewModel?.loadDepositors()
        tableView.reloadData()
    }
    
}

extension DepositorViewController : DepositorCreationDelegate {
    func didSaveDepositor() {
        didUpdate()
        delegate?.didSaveDepositorFromList()
    }
}

extension DepositorViewController : NSTableViewDelegate {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return viewModel?.numberOfRows ?? 0
    }
}

extension DepositorViewController : NSTableViewDataSource {
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard
            let viewModel = viewModel,
            let headerTag = tableColumn?.headerCell.tag,
            let columnType = DepositorColumnType(rawValue: headerTag),
            let rowContent = viewModel.contentForCell(at: row, for: columnType),
            let view: OverViewView = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "OverviewView"), owner: self) as? OverViewView else {
                return NSView()
        }
        view.textLabel.stringValue = rowContent
        return view
    }
    
}

extension DepositorViewController: Observable {
    func notifyDataDidChange() {
        didUpdate()
    }
}
