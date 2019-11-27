//
//  FiveHexagonsViewController.swift
//  DuetMonitor
//
//  Created by Jing Wei Li on 11/25/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import Cocoa

class FiveHexagonsViewController: NSViewController {
    @IBOutlet weak var fastSpeedTextField: NSTextField!
    @IBOutlet weak var printSpeedTextField: NSTextField!
    @IBOutlet weak var zAxisExtTextField: NSTextField!
    @IBOutlet weak var augerRatioTextField: NSTextField!
    @IBOutlet weak var pumpRatioTextField: NSTextField!
    @IBOutlet weak var generateGCodeButton: NSButton!
    @IBOutlet weak var saveToDiskButton: NSButton!
    @IBOutlet weak var gCodeTextView: NSScrollView!
    
    var gCode = ""
    let viewModel = FiveHexagonsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fastSpeedTextField.stringValue = "5000"
        printSpeedTextField.stringValue = "4500"
        augerRatioTextField.stringValue = "1.0"
        zAxisExtTextField.stringValue = "15.0"
        saveToDiskButton.isEnabled = false
    }
    
    // MARK: - Actions
    
    
    @IBAction func generateGCodeButtonTapped(_ sender: NSButton) {
        (gCodeTextView.documentView as? NSTextView)?.string = ""
        if let gCode = generateHexagons() {
            saveToDiskButton.isEnabled = true
            gCodeTextView.documentView?.insertText(gCode)
        } else {
            saveToDiskButton.isEnabled = false
            gCodeTextView.documentView?.insertText(NSAttributedString(errorString: "Error: Invalid Input"))
        }
    }
    
    @IBAction func saveToDiskButtonTapped(_ sender: Any) {
        saveToDisk { [weak self] error in
            if let error = error {
                (self?.gCodeTextView.documentView as? NSTextView)?.string = ""
                self?.gCodeTextView.documentView?.insertText(NSAttributedString(errorString: error.localizedDescription))
            }
        }
    }
    
    // MARK: - Functionality
    func generateHexagons() -> String? {
        if let fastSpeed = Int(fastSpeedTextField.stringValue),
            let printSpeed = Int(printSpeedTextField.stringValue),
            let zAxisExt = Double(zAxisExtTextField.stringValue),
            let augerRatio = Double(augerRatioTextField.stringValue),
            let pumpRaito = Double(pumpRatioTextField.stringValue) {
            return viewModel.writeGCode(
                fastSpeed: fastSpeed, printSpeed: printSpeed, zAxisExt: zAxisExt,
                augerRatio: augerRatio, pumpRatio: pumpRaito)
        } else {
            return nil
        }
        
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
