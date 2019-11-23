//
//  String+Error.swift
//  DuetMonitor
//
//  Created by Jing Wei Li on 11/22/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import Foundation

extension String: Error {
    
}

extension String: LocalizedError {
    public var errorDescription: String? {
        return "Error: " + self
    }
}

