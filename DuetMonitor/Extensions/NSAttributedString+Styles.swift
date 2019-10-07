//
//  NSAttributedString+Styles.swift
//  DuetMonitor
//
//  Created by Jing Wei Li on 10/5/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import Cocoa

extension NSAttributedString {
    convenience init(instructionString: String) {
        self.init(string: instructionString, attributes: [
            NSAttributedString.Key.foregroundColor: NSColor.green,
            NSAttributedString.Key.font: NSFont.boldSystemFont(ofSize: 13)
        ])
    }
    
    convenience init(errorString: String) {
        self.init(string: errorString, attributes: [
            NSAttributedString.Key.foregroundColor: NSColor.red,
            NSAttributedString.Key.font: NSFont.boldSystemFont(ofSize: 13)
        ])
    }
}
