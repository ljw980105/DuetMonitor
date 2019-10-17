//
//  DuetDataType.swift
//  DuetMonitor
//
//  Created by Jing Wei Li on 10/5/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import Foundation

enum DuetDataType {
    case ipAddress(ip: String)
    case firmwareVersion(verion: String)
    case firmwareDate(date: String)
    
    var type: String {
        switch self {
        case .ipAddress(_):
            return "IP Address"
        case .firmwareDate(_):
            return "Firmware date"
        case .firmwareVersion(_):
            return "Firmware version"
        }
    }
}
