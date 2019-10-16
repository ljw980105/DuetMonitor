//
//  SavedDataViewModel.swift
//  DuetMonitor
//
//  Created by Jing Wei Li on 10/15/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import Cocoa

struct SavedData {
    let name: String
    let value: String
}

enum SavedDataTableIdentifiers: String {
    case dataType = "dataTypeIdentifier"
    case value = "valueIdentifier"
}

class SavedDataViewModel: NSObject {
    let data: [SavedData] = [
        SavedData(name: "IP Address", value: "192.168.1.10"),
        SavedData(name: "Firmware version", value: "2.02")
    ]
    
    override init() {
        super.init()
    }

}
