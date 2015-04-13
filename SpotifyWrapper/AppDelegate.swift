//
//  AppDelegate.swift
//  SpotifyWrapper
//
//  Created by Mihai Costea on 10/04/15.
//  Copyright (c) 2015 Skobbler. All rights reserved.
//

import Cocoa
import CoreGraphics

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        
        NSWorkspace.sharedWorkspace().notificationCenter.addObserver(self, selector: "sleepNotification:", name: NSWorkspaceWillSleepNotification, object: nil)
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }

    func applicationShouldHandleReopen(sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        if flag {
            return false
        }
        
        NSNotificationCenter.defaultCenter().postNotificationName("kSWReopenWindowNotification", object: nil)
        
        return true
    }
    
    // MARK:- Notifications
    
    func sleepNotification(notif: NSNotification) {
        
    }
    
}

