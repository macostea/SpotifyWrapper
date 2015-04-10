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
    
    var eventTap: CFMachPortRef?
    var eventPortSource: CFRunLoopSourceRef?
    var eventTapCallback = {(tapProxy: CGEventTapProxy, eventType: CGEventType, event: CGEvent!, refcon: UnsafeMutablePointer<Void>) -> Unmanaged<CGEvent>! in
        
        let appDelegate = Unmanaged<AppDelegate>.fromOpaque(COpaquePointer(refcon)).takeRetainedValue()
        if eventType == kCGEventTapDisabledByTimeout || eventType == kCGEventTapDisabledByUserInput {
            CGEventTapEnable(appDelegate.eventTap, true)
        }
        
        if (eventType != UInt32(NX_SYSDEFINED)) {
            return Unmanaged<CGEvent>.passRetained(event)
        }
        
        let keyEvent = NSEvent(CGEvent: event)!
        if keyEvent.subtype != NSEventSubtype(rawValue: 8) {
            return Unmanaged<CGEvent>.passRetained(event)
        }
        
        let keyCode = ((keyEvent.data1 & 0xFFFF0000) >> 16);
        let keyFlags = (keyEvent.data1 & 0x0000FFFF);
        let keyState = (((keyFlags & 0xFF00) >> 8)) == 0xA;
        
        var err: OSStatus?
        var psn: ProcessSerialNumber?
        let runningApp = NSRunningApplication(processIdentifier: pid_t(NSProcessInfo.processInfo().processIdentifier))
        
        if keyCode == Int(NX_KEYTYPE_PLAY) {
            if keyState == true {
                // Play things
                println("Play pressed")
            }
            
            return nil
        } else if keyCode == Int(NX_KEYTYPE_FAST) || keyCode == Int(NX_KEYTYPE_NEXT) {
            if keyState == true {
                // forward
                println("Forward pressed")
            }
            
            return nil
        } else if keyCode == Int(NX_KEYTYPE_REWIND) || keyCode == Int(NX_KEYTYPE_PREVIOUS) {
            if keyState == true {
                // back
                println("Back pressed")
            }
            
            return nil
        }
        
        return Unmanaged<CGEvent>.passRetained(event)
    }
    

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        
        NSWorkspace.sharedWorkspace().notificationCenter.addObserver(self, selector: "sleepNotification:", name: NSWorkspaceWillSleepNotification, object: nil)
        
        self.addEventTap()
        
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

    
    // MARK:- Private
    
    private func addEventTap() {
        let mask = CGEventMask.max

        let appDelegatePtr = UnsafeMutablePointer<Void>(Unmanaged<AppDelegate>.passRetained(self).toOpaque())
        
        var ump = UnsafeMutablePointer<(CGEventTapProxy, CGEventType, CGEvent!, UnsafeMutablePointer<Void>) -> Unmanaged<CGEvent>!>.alloc(1)
        ump.initialize(self.eventTapCallback)
        
        let cp = COpaquePointer(ump)
        let fp: CGEventTapCallBack = CFunctionPointer<((CGEventTapProxy, CGEventType, CGEvent!, UnsafeMutablePointer<Void>) -> Unmanaged<CGEvent>!)>(cp)
        
        self.eventTap = CGEventTapCreate(UInt32(kCGSessionEventTap), UInt32(kCGHeadInsertEventTap), UInt32(kCGEventTapOptionDefault), mask, fp, appDelegatePtr).takeRetainedValue()
        
        self.eventPortSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, self.eventTap!, 0)
        CGEventTapEnable(self.eventTap, true)
        
        NSThread.detachNewThreadSelector("eventTapThread", toTarget: self, withObject: nil)
        
    }
    
    func eventTapThread() {
        let tapThreadRunLoop = CFRunLoopGetCurrent()
        
        CFRunLoopAddSource(tapThreadRunLoop, self.eventPortSource!, kCFRunLoopCommonModes)
        CFRunLoopRun()
    }
}

