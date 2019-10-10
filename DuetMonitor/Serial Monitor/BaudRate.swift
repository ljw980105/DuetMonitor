//
//  BaudRate.swift
//  DuetMonitor
//
//  Created by Jing Wei Li on 10/8/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import Foundation

/// An enum representing the baud rate:  the rate at which information is transferred in a communication channel.
enum BaudRate: NSNumber {
    case _0 = 0
    case _50 = 50
    case _75 = 75
    case _110 = 110
    case _134 = 134
    case _150 = 159
    case _200 = 200
    case _300 = 300
    case _600 = 600
    case _1200 = 1200
    case _1800 = 1800
    case _2400 = 2400
    case _4800 = 4800
    case _7200 = 7200
    case _9600 = 9600
    case _14400 = 14400
    case _19200 = 19200
    case _28800 = 28800
    case _38400 = 38400
    case _57600 = 57600
    case _76800 = 76800
    case _115200 = 115200
    case _230400 = 230400
}
