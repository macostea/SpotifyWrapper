//
//  SWWebView.swift
//  SpotifyWrapper
//
//  Created by Mihai Costea on 13/04/15.
//  Copyright (c) 2015 Skobbler. All rights reserved.
//

import Cocoa
import WebKit

class SWWebView: WebView {
    private var warnedAboutPlugin = false
    
    override func webView(sender: WebView!, plugInFailedWithError error: NSError!, dataSource: WebDataSource!) {
        if (!self.warnedAboutPlugin) {
            self.warnedAboutPlugin = true;
            
            let pluginName = error.userInfo![WebKitErrorPlugInNameKey] as! String
            let pluginUrl = NSURL(string: error.userInfo![WebKitErrorPlugInPageURLStringKey] as! String)
            let reason = error.userInfo![NSLocalizedDescriptionKey] as! String
            
            let alert = NSAlert()
            alert.messageText = reason
            alert.addButtonWithTitle("Download plug-in update...")
            alert.addButtonWithTitle("OK")
            alert.informativeText = "\(pluginName) plug-in could not be loaded and may be out-of-date. You will need to download the latest plug-in update from within Safari, and restart Spotify Wrapper once it is installed."
            
            let response = alert.runModal()
            
            if (response == NSAlertFirstButtonReturn) {
                NSWorkspace.sharedWorkspace().openURL(pluginUrl!)
            }
        }
    }
}
