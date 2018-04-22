//
//  ViewController.swift
//  Buchhaltung
//
//  Created by Paul Neuhold on 11.02.18.
//  Copyright © 2018 Paul Neuhold. All rights reserved.
//

import Cocoa

protocol StartViewControllerDelegate : class {
    func didPressSave()
    func didSaveSuccessFully()
}

protocol Observable : class {
    func notifyDataDidChange()
}

class StartViewController: NSViewController {

    var observers: [Observable]? = []

    @IBOutlet weak var transactionContainerView: NSView!
    @IBOutlet weak var segmentedControll: NSSegmentedControl!
    weak var delegate: StartViewControllerDelegate?
    
    lazy var transactionViewController: TransactionInputViewController = {
        let controller = TransactionInputViewController.create(viewModel: TransactionInputViewModel())
        controller.delegate = self
        delegate = controller
        observers?.append(controller)
        return controller
    }()
    
    lazy var overViewWindowController: WindowController = {
        let controller = OverviewController.create(viewModel: OverviewViewModel())
        let window : Window = Window(contentViewController: controller)
        let windowController = WindowController(window: window)
        observers?.append(controller)
        return windowController
    }()
    
    lazy var depositorListController: WindowController = {
        let controller = DepositorViewController.create(viewModel: DepositorViewModel())
        let window : Window = Window(contentViewController: controller)
        let windowController = WindowController(window: window)
        controller.delegate = self
        observers?.append(controller)
        return windowController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    func setupUI(){
        segmentedControll.selectedSegment = 0
        self.title = "Buchhaltung"
        add(asChildViewController: transactionViewController)
    }
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    private func add(asChildViewController viewController: NSViewController) {
        // Add Child View Controller
        addChildViewController(viewController)
        
        // Add Child View as Subview
        self.transactionContainerView.addSubview(viewController.view)
        
        // Configure Child View
        viewController.view.frame = self.transactionContainerView.bounds
        
    }
    
    private func remove(asChildViewController viewController: NSViewController) {
        // Remove Child View From Superview
        viewController.view.removeFromSuperview()

        // Notify Child View Controller
        viewController.removeFromParentViewController()
    }

    @IBAction func segmentAction(_ sender: NSSegmentedControl) {
        switch sender.selectedSegment {
        case 0:
            add(asChildViewController: transactionViewController)
            break
        default:
            remove(asChildViewController: transactionViewController)
        }
    }
    
    @IBAction func didSave(_ sender: NSButton) {
        delegate?.didPressSave()
    }
    
    @IBAction func didPressOverview(_ sender: NSButton) {
        overViewWindowController.showWindow(self)
    }
    
    func persistTransaction(transaction: Transaction){
        if DataBaseController.shared.saveAndReturnQuitStatus() == .terminateNow {
            delegate?.didSaveSuccessFully()
            notifiyObservers()
            print("Save Transaction Success")
        } else {
            print("error - saving Transaction")
        }
    }
    
    func notifiyObservers(){
        observers?.forEach{
            $0.notifyDataDidChange()
        }
    }
}

extension StartViewController : DepositorCreationDelegate {
    func didSaveDepositor() {
        notifiyObservers()
    }
}

extension StartViewController : DepositorDelegate {
    func didSaveDepositorFromList(){
        notifiyObservers()
    }
}

extension StartViewController : TransactionInputDelegate {
    func saveData(transaction: Transaction) {
        persistTransaction(transaction: transaction)
    }
    
    func openAddDepositorPopup() {
        let controller = DepositorCreationViewController.create(viewModel: DepositorCreationViewModel())
        controller.delegate = self
        presentViewControllerAsModalWindow(controller)
    }
    
    func openDepositorList() {
        depositorListController.showWindow(self)
    }
}


