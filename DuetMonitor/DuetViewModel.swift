//
//  DuetViewModel.swift
//  DuetMonitor
//
//  Created by Jing Wei Li on 10/4/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import Cocoa

class DuetViewModel: NSObject {
    var ipAddress: String = ""
    var duetName: String = ""
    let pasteboard = NSPasteboard.general
    let terminalInstructionString = "The terminal command has been copied to clipboard. Paste it into terminal and then run it to control duet via terminal\n"
    let connectDuetInstructionString = "Connect Duet to this computer via usb\n"
    
    override init() {
        super.init()
    }
    
    func copyIPToClipboard() {
        pasteboard.declareTypes([.string], owner: nil)
        pasteboard.setString(ipAddress, forType: .string)
    }
    
    func openIPInBroser() {
        NSWorkspace.shared.open(URL(string: "http://\(ipAddress)".trimmingCharacters(in: .whitespacesAndNewlines))!)
    }
    
    func openInTerminal() {
        pasteboard.declareTypes([.string], owner: nil)
        pasteboard.setString("screen /dev/\(duetName) 115200", forType: .string)
        
        guard let url = NSWorkspace.shared.urlForApplication(withBundleIdentifier: "com.apple.Terminal") else { return }
        NSWorkspace.shared.open(url)
    }
    
    
}
