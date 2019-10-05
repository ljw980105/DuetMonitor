//
//  SerialMonitorDelegate.swift
//  DuetMonitor
//
//  Created by Jing Wei Li on 10/3/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import Foundation
import ORSSerial

protocol SerialMonitorDelegate: class {
    func monitor(_ monitor: SerialMonitor, didReceiveString string: String)
    func monitor(_ monitor: SerialMonitor, didReceiveDuetData data: DuetDataType)
    func monitor(_ monitor: SerialMonitor, didEncounterError error: Error)
    func monitorDidDisconnect(_ monitor: SerialMonitor)
}
