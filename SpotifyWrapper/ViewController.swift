//
//  ViewController.swift
//  SpotifyWrapper
//
//  Created by Mihai Costea on 10/04/15.
//  Copyright (c) 2015 Skobbler. All rights reserved.
//

import Cocoa
import WebKit

class ViewController: NSViewController {

    @IBOutlet weak var webView: WebView!
    
    var mediaKeyTap: SPMediaKeyTap?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let userAgent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_3) AppleWebKit/600.5.17 (KHTML, like Gecko) Version/8.0.5 Safari/600.5.17"
        let url = "http://play.spotify.com"
        
        self.webView.preferences.javaScriptEnabled = true
        self.webView.preferences.javaScriptCanOpenWindowsAutomatically = true
        
        self.webView.customUserAgent = userAgent
        self.webView.mainFrameURL = url
        
        self.addMediaKeyesTap()

    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    // MARK:- Private
    
    func playPause() {
        self.webView.stringByEvaluatingJavaScriptFromString("var iframe = document.getElementById('app-player');" +
                                                    "var key = iframe.contentDocument.getElementById('play-pause');" +
                                                    "key.click();"
        )
    }
    
    func forward() {
        self.webView.stringByEvaluatingJavaScriptFromString("var iframe = document.getElementById('app-player');" +
                                                    "var key = iframe.contentDocument.getElementById('next');" +
                                                    "key.click();"
        )
    }
    
    func back() {
        self.webView.stringByEvaluatingJavaScriptFromString("var iframe = document.getElementById('app-player');" +
                                                    "var key = iframe.contentDocument.getElementById('previous');" +
                                                    "key.click();"
        )
    }
    
    // MARK:- SPMediaKeyTapDelegate
    
    override func mediaKeyTap(keyTap: SPMediaKeyTap!, receivedMediaKeyEvent event: NSEvent!) {
        let keyCode = ((event.data1 & 0xFFFF0000) >> 16);
        let keyFlags = (event.data1 & 0x0000FFFF);
        let keyState = (((keyFlags & 0xFF00) >> 8)) == 0xA;
        let keyRepeat = (keyFlags & 0x1);
        
        if (keyState == true) {
            
            switch (keyCode) {
                
            case Int(NX_KEYTYPE_PLAY):
                // Play things
                println("Play pressed")
                self.playPause()
                
            case Int(NX_KEYTYPE_FAST):
                // Next
                println("Next pressed")
                self.forward()
                
            case Int(NX_KEYTYPE_REWIND):
                // Back
                println("Back pressed")
                self.back()
                
            default:
                // Other keyes
                println("Other key pressed")
            }
        }
        
    }
    
    // MARK:- Private
    
    func addMediaKeyesTap() {
        self.mediaKeyTap = SPMediaKeyTap(delegate: self)
        
        if (SPMediaKeyTap.usesGlobalMediaKeyTap()) {
            self.mediaKeyTap?.startWatchingMediaKeys()
        } else {
            println("Media key monitoring disabled")
        }
    }

}

