//
//  SerialMonitor.swift
//  DuetMonitor
//
//  Created by Jing Wei Li on 10/3/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import Foundation
import ORSSerial

class SerialMonitor: NSObject {
    let name: String?
    var baudRate: BaudRate = ._115200
    var serialPort: ORSSerialPort? {
        didSet {
            serialPort?.delegate = self
            serialPort?.open()
            print("opening port \(serialPort?.name ?? "")")
        }
    }
    
    weak var delegate: SerialMonitorDelegate?
    
    // MARK: - Initializers
    
    init(name: String, baudRate: BaudRate = ._115200) {
        self.name = name
        self.baudRate = baudRate
        super.init()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.serialPort = ORSSerialPort(path: "/dev/\(name)")
        }
    }
    
    init?(availablePorts: [ORSSerialPort] = ORSSerialPortManager.shared().availablePorts) {
        if let port = availablePorts.filter ({ $0.name.contains("usb") }).first {
            name = port.name
            super.init()
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
                self?.serialPort = port
            }
        } else {
            return nil
        }
    }
    
    // MARK: - Methods
    
    func send(string: String) {
        if let data = string.data(using: .utf8), let sent = serialPort?.send(data) {
            print("Data sent: \(sent)")
            print("port open: \(serialPort!.isOpen)")
        }
    }
    
    func close() {
        serialPort?.close()
    }
}

// MARK: - ORSSerialPortDelegate
extension SerialMonitor: ORSSerialPortDelegate {
    func serialPortWasRemovedFromSystem(_ serialPort: ORSSerialPort) {
        if self.serialPort == serialPort {
            delegate?.monitorDidDisconnect(self)
            delegate?.monitor(self, didEncounterError: NSError(domain: "\(name ?? "") has been removed from system", code: 0, userInfo: nil))
            self.serialPort = nil
        }
    }
    
    func serialPortWasOpened(_ serialPort: ORSSerialPort) {
        serialPort.baudRate = baudRate.rawValue
    }
    
    func serialPort(_ serialPort: ORSSerialPort, didReceive data: Data) {
        if let string = String(data: data, encoding: .utf8) {
            delegate?.monitor(self, didReceiveString: string)
            if string.contains("IP address") {
                if let iPAddress = string.components(separatedBy: ",").last?.components(separatedBy: " ").last {
                    let ip = iPAddress.trimmingCharacters(in: .whitespacesAndNewlines)
                    delegate?.monitor(self, didReceiveDuetData: .ipAddress(ip: ip))
                    SavedData.set(type: DuetDataType.ipAddress(ip: ip).type, value: ip)
                }
            } else if string.contains("RepRapFirmware") {
                let chunks = string
                    .trimmingCharacters(in: .whitespacesAndNewlines)
                    .split(separator: " ")
                    .map { String($0) }
                let version = chunks[6]
                let date = chunks[8]
                delegate?.monitor(self, didReceiveDuetData: DuetDataType.firmwareVersion(verion: version))
                delegate?.monitor(self, didReceiveDuetData: .firmwareDate(date: date))
                SavedData.set(type: DuetDataType.firmwareDate(date: date).type, value: date)
                SavedData.set(type: DuetDataType.firmwareVersion(verion: version).type, value: date)
            }
            try? SavedDataManager.save()
        }
    }
    
    func serialPort(_ serialPort: ORSSerialPort, didEncounterError error: Error) {
        delegate?.monitor(self, didEncounterError: error)
    }
}


