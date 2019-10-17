//
//  DuetViewController.swift
//  DuetMonitor
//
//  Created by Jing Wei Li on 10/3/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import Cocoa
import ORSSerial

class DuetViewController: NSViewController {
    @IBOutlet weak var textView: NSScrollView!
    @IBOutlet weak var nameLabel: NSTextField!
    @IBOutlet weak var connectedStatusLabel: NSTextField!
    @IBOutlet weak var ipAddressLabel: NSTextField!
    @IBOutlet weak var viewIPButton: NSButton!
    @IBOutlet weak var openInTerminalButton: NSButton!

    var serialMonitor: SerialMonitor?
    let viewModel = DuetViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        Shell.shared.delegate = self
        //shell.shell(args: "ls")
        Shell.shared.identifyDuet()
        viewIPButton.isEnabled = false
        openInTerminalButton.isEnabled = false
        textView.documentView?.insertText(NSAttributedString(instructionString: viewModel.connectDuetInstructionString))
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(serialPortsWereConnected),
            name: NSNotification.Name.ORSSerialPortsWereConnected,
            object: nil)
    
    }
    
    @objc func serialPortsWereConnected() {
        Shell.shared.identifyDuet()
    }
    
    // MARK: - IBActions
    
    @IBAction func viewiP(_ sender: NSButton) {
        viewModel.openIPInBroser()
    }
    
    @IBAction func controlInTerminal(_ sender: NSButton) {
        serialMonitor?.close()
        viewModel.openInTerminal()
        textView.documentView?.insertText(NSAttributedString(instructionString: viewModel.terminalInstructionString))
    }
    
}

// MARK: - Extensions
extension DuetViewController: ShellDelegate {
    func shell(_ shell: Shell, didReceiveOutput output: String, launchPath: String, commandType: ShellCommandType) {
        textView.documentView?.insertText("\(output)\n")
    }
    
    func shell(_ shell: Shell, didReceiveError error: String, launchPath: String, commandType: ShellCommandType) {
        textView.documentView?.insertText("\(error)\n")
    }
    
    func shell(_ shell: Shell, didIdentifyDuetName name: String) {
        nameLabel.stringValue = name
        connectedStatusLabel.stringValue = "Connected ✅"
        serialMonitor = SerialMonitor()
        serialMonitor?.delegate = self
        viewModel.duetName = name
        openInTerminalButton.isEnabled = true
    }
}

extension DuetViewController: NSTextFieldDelegate {
    func control(_ control: NSControl, textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
        if (commandSelector == #selector(NSResponder.insertNewline(_:))) {
            // Do something against ENTER key
            let text = textView.string
            print(text)
            textView.string.removeAll()
            serialMonitor?.send(string: text)
        }
        return true
    }
}

extension DuetViewController: SerialMonitorDelegate {
    func monitor(_ monitor: SerialMonitor, didReceiveString string: String) {
        textView.documentView?.insertText("\(string)\n")
    }
    
    func monitor(_ monitor: SerialMonitor, didReceiveDuetData data: DuetDataType) {
        switch data {
        case .ipAddress(let ip):
            ipAddressLabel.stringValue = "IP Address: \(ip)"
            viewIPButton.isEnabled = true
            viewModel.ipAddress = ip
        default: break
        }
    }
    
    func monitorDidDisconnect(_ monitor: SerialMonitor) {
        nameLabel.stringValue = "Unknown"
        connectedStatusLabel.stringValue = "Disconnected ❌"
        viewIPButton.isEnabled = false
        openInTerminalButton.isEnabled = false
        ipAddressLabel.stringValue = "IP Address: Unknown"
    }
    
    func monitor(_ monitor: SerialMonitor, didEncounterError error: Error) {
        textView.documentView?.insertText(NSAttributedString(errorString: error.localizedDescription))
    }
    
}

