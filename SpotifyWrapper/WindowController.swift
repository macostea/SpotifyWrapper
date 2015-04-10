//
//  WindowController.swift
//  SpotifyWrapper
//
//  Created by Mihai Costea on 10/04/15.
//  Copyright (c) 2015 Skobbler. All rights reserved.
//

import Cocoa

class WindowController: NSWindowController, NSWindowDelegate {

    override func windowDidLoad() {
        super.windowDidLoad()
    
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reopenWindow:", name: "kSWReopenWindowNotification", object: nil)
        self.window?.delegate = self
    }
    
    func reopenWindow(notif: NSNotification) {
        self.window?.makeKeyAndOrderFront(self)
    }
    
    func windowShouldClose(sender: AnyObject) -> Bool {
        self.window?.orderOut(sender)
        NSApp.hide(self)
        return false
    }
    
}
