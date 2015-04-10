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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let userAgent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_3) AppleWebKit/600.5.17 (KHTML, like Gecko) Version/8.0.5 Safari/600.5.17"
        let url = "http://play.spotify.com"
        
        self.webView.customUserAgent = userAgent
        self.webView.mainFrameURL = url
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

