//
//  DepositorCreationViewController.swift
//  Buchhaltung
//
//  Created by Paul Neuhold on 03.03.18.
//  Copyright © 2018 Paul Neuhold. All rights reserved.
//

import Cocoa

public enum DepositorInputFieldTypes : Int {
    case firstName = 0
    case lastName = 1
}

protocol DepositorCreationDelegate : class {
    func didSaveDepositor()
}

final class DepositorCreationViewController : NSViewController {
    
    var viewModel : DepositorCreationViewModel?
    
    @IBOutlet weak var firstNameTextfield: NSTextField!
    @IBOutlet weak var lastnameTextField: NSTextField!
    weak var delegate: DepositorCreationDelegate?
    
    class func create(viewModel: DepositorCreationViewModel) -> DepositorCreationViewController {
        let storyBoard: NSStoryboard = NSStoryboard(name: NSStoryboard.Name(rawValue: "Depositor"), bundle: nil)
        let viewController: DepositorCreationViewController = storyBoard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "DepositorCreationViewController")) as! DepositorCreationViewController
        viewController.viewModel = viewModel
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if viewModel == nil {
            viewModel = DepositorCreationViewModel()
        }
        setupUI()
    }
    
    func setupUI() {
        firstNameTextfield.delegate = self
        firstNameTextfield.placeholderString = "Max"
        firstNameTextfield.tag = DepositorInputFieldTypes.firstName.rawValue
        
        lastnameTextField.delegate = self
        lastnameTextField.placeholderString = "Musterfrau"
        lastnameTextField.tag = DepositorInputFieldTypes.lastName.rawValue
    
    }
    @IBAction func saveDepositor(_ sender: NSButton) {
       saveDepositor()
    }
    
    func saveDepositor() {
        guard let viewModel = viewModel else {
            return
        }
        storeInputValues()
        if viewModel.createDepositorAndSave() {
            delegate?.didSaveDepositor()
            self.dismiss(nil)
        } else {
            presentAlert(message: "Einzahler konnte nicht gespeichert werden", additionalInfo: "Bitte überprüfen sie die Eingabefelder oder versuchen sie es erneut" , buttonText: "OK")
        }
    }
    
    func storeInputValues() {
        guard let viewModel = viewModel else {
            return
        }
        viewModel.firstName = firstNameTextfield.stringValue
        viewModel.lastName = lastnameTextField.stringValue
        
    }
    
    func attachFirstResponder(with tag: Int) {
        guard let type = DepositorInputFieldTypes(rawValue: tag) else {
            return
        }
        switch type {
        case .firstName:
            lastnameTextField.becomeFirstResponder()
            return
        case .lastName:
            saveDepositor()
            return
        }
    }
    
}

extension DepositorCreationViewController : NSTextFieldDelegate {
    func control(_ control: NSControl, textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
        print("control Desc: \(commandSelector.description)")
        if commandSelector == #selector(NSResponder.insertNewline(_:)) || commandSelector == #selector(NSResponder.insertTab(_:)) {
            attachFirstResponder(with: control.tag)
        }
        return false
    }
}
