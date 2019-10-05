//
//  DuetViewModel.swift
//  DuetMonitor
//
//  Created by Jing Wei Li on 10/3/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import Foundation

class Shell: NSObject {
    let baudRate = 115200
    var name: String = ""
    
    weak var delegate: ShellDelegate?
    static let shared = Shell()
    
    override private init() {
        super.init()
    }
    
    @discardableResult
    func shell(args: [String], launchPath: String = "/usr/bin/env", commandType: ShellCommandType = .generic) -> Int32 {
        var output : [String] = []
        var error : [String] = []

        let task = Process()
        task.launchPath = launchPath//"/bin/sh"
        task.arguments = args

        let outpipe = Pipe()
        task.standardOutput = outpipe
        let errpipe = Pipe()
        task.standardError = errpipe

        task.launch()

        let outdata = outpipe.fileHandleForReading.readDataToEndOfFile()
        if var string = String(data: outdata, encoding: .utf8) {
            string = string.trimmingCharacters(in: .newlines)
            output = string.components(separatedBy: "\n")
            if commandType == .listDevices {
                if let device = output.filter ({ $0.contains("tty.usb") }).first {
                    delegate?.shell(self, didIdentifyDuetName: device)
                    name = device
                }
            } else {
                delegate?.shell(self, didReceiveOutput: output.joined(separator: " "), launchPath: launchPath, commandType: commandType)
            }
        }

        let errdata = errpipe.fileHandleForReading.readDataToEndOfFile()
        if var string = String(data: errdata, encoding: .utf8) {
            string = string.trimmingCharacters(in: .newlines)
            error = string.components(separatedBy: "\n")
            delegate?.shell(self, didReceiveError: error.joined(separator: " "), launchPath: launchPath, commandType: commandType)
        }

        task.waitUntilExit()
        return task.terminationStatus
    }
    
    func identifyDuet() {
        shell(args: ["ls", "/dev"], commandType: .listDevices)
    }
    
    func screenDuet() {
        shell(args: ["screen", name, "115200"], commandType: .screen)
    }
}
