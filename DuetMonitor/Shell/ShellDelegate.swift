//
//  ShellDelegate.swift
//  DuetMonitor
//
//  Created by Jing Wei Li on 10/3/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import Foundation

protocol ShellDelegate: class {
    func shell(_ shell: Shell, didReceiveOutput output: String, launchPath: String, commandType: ShellCommandType)
    func shell(_ shell: Shell, didReceiveError error: String, launchPath: String, commandType: ShellCommandType)
    func shell(_ shell: Shell, didIdentifyDuetName name: String)
}
