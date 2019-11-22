//
//  PumpAugerControlViewController.swift
//  DuetMonitor
//
//  Created by Jing Wei Li on 11/22/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import Cocoa

class PumpAugerControlViewController: NSViewController {
    @IBOutlet weak var pumpURatioTextField: NSTextField!
    @IBOutlet weak var pumpWRatioTextField: NSTextField!
    @IBOutlet weak var augerVRatioTextField: NSTextField!
    @IBOutlet weak var distaneTextField: NSTextField!
    @IBOutlet weak var feedRateTextField: NSTextField!
    @IBOutlet weak var gCodeTextView: NSScrollView!
    @IBOutlet weak var generateGCodeButton: NSButton!
    @IBOutlet weak var saveToDiskButton: NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        saveToDiskButton.isEnabled = false
    }
    
    // MARK: - IBActions
    @IBAction func generateGCodeButtonTapped(_ sender: NSButton) {
        (gCodeTextView.documentView as? NSTextView)?.string = ""
        if let gCode = generateGCode() {
            saveToDiskButton.isEnabled = true
            gCodeTextView.documentView?.insertText(gCode)
        } else {
            saveToDiskButton.isEnabled = false
            gCodeTextView.documentView?.insertText(NSAttributedString(errorString: "Error: Invalid Input"))
        }
    }
    
    @IBAction func saveToDiskButtonTapped(_ sender: NSButton) {
        saveToDisk { [weak self] error in
            if let error = error {
                (self?.gCodeTextView.documentView as? NSTextView)?.string = ""
                self?.gCodeTextView.documentView?.insertText(NSAttributedString(errorString: error.localizedDescription))
            }
        }
    }
    
    // MARK: - Functionality
    func generateGCode() -> String? {
        guard let uRatio = Double(pumpURatioTextField.stringValue),
            let wRatio = Double(pumpWRatioTextField.stringValue),
            let augerRatio = Double(augerVRatioTextField.stringValue),
            let distance = Int(distaneTextField.stringValue),
            let feedRate = Int(feedRateTextField.stringValue) else {
                return nil
            }
        return """
        N1 M567 P0 E\(String(format: "%.2f:%.2f:%.2f", uRatio, wRatio, augerRatio))
        N2 G1 E\(distance) F\(feedRate)
        """
    }
    
    func saveToDisk(error: @escaping (Error?) -> Void) {
        let panel = NSSavePanel()
        panel.allowedFileTypes = ["g"]
        panel.begin { [weak self] response in
            if response == .OK {
                guard let filename = panel.url else {
                    error("Invalid Save URL")
                    return
                }
                do {
                    guard let text = (self?.gCodeTextView.documentView as? NSTextView)?.string, !text.isEmpty else {
                        error("No G-Code Provided")
                        return
                    }
                    try text.write(to: filename, atomically: true, encoding: .utf8)
                    error(nil)
                } catch let err {
                    error(err)
                }
            }
        }
    }
}
