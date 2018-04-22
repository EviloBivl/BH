//
//  AppDelegate.swift
//  Buchhaltung
//
//  Created by Paul Neuhold on 11.02.18.
//  Copyright © 2018 Paul Neuhold. All rights reserved.
//

import Cocoa
import AppKit

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {


    
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        initDataSets()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    
    func applicationShouldTerminate(_ sender: NSApplication) -> NSApplication.TerminateReply {
        // Save changes in the application's managed object context before the application terminates.
        return DataBaseController.shared.saveAndReturnQuitStatus()
        
    }

    func windowWillReturnUndoManager(window: NSWindow) -> UndoManager? {
        // Returns the NSUndoManager for the application. In this case, the manager returned is that of the managed object context for the application.
        return DataBaseController.shared.viewContext.undoManager
    }
    
    func initDataSets(){
       // DataBaseController.shared.deleteAllData()
        DataBaseController.shared.loadTaxesIntoData()
        DataBaseController.shared.loadAccountsIntoMemory()
    }
    

    
    @IBOutlet weak var importDepositors: NSMenuItem!
    
    
    @IBAction func importDepositors(_ sender: NSMenuItem) {
         let dialog = NSOpenPanel();
        
        dialog.title                   = "Choose a .json file";
        dialog.showsResizeIndicator    = true;
        dialog.showsHiddenFiles        = false;
        dialog.canChooseDirectories    = true;
        dialog.canCreateDirectories    = true;
        dialog.allowsMultipleSelection = false;
        dialog.allowedFileTypes        = ["json"];
        
        if (dialog.runModal() == NSApplication.ModalResponse.OK) {
            let result = dialog.url?.absoluteString // Pathname of the file
            if let fileName = result {
                let json = ImportHandler.shared.readJsonFile(fileName: fileName)
                print("SelectedFile Content in json: \(String(describing:json))")
            }
        } else {
            // User clicked on "Cancel"
            return
        }
    }
    
    
    @IBAction func saveAs(_ sender: Any) {
    }
    @IBAction func delete(_ sender: Any) {
    }
    
    
    
}

extension AppDelegate : NSUserInterfaceValidations {
    func validateUserInterfaceItem(_ item: NSValidatedUserInterfaceItem) -> Bool {
        print("menuItem \(item)")
        return true
    }
}

