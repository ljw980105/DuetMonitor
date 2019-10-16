//
//  WindowController.swift
//  DuetMonitor
//
//  Created by Jing Wei Li on 10/4/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import Cocoa

class WindowController: NSWindowController {
    var tabViewController: NSTabViewController?
    
    override func windowDidLoad() {
        super.windowDidLoad()
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
        tabViewController = window?.contentViewController as? NSTabViewController
        tabViewController?.selectedTabViewItemIndex = 0
    }
    
    @IBAction func switchVCs(_ sender: NSSegmentedControl) {
        tabViewController?.selectedTabViewItemIndex = sender.selectedSegment
    }
    
}
