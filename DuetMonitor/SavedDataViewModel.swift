//
//  SavedDataViewModel.swift
//  DuetMonitor
//
//  Created by Jing Wei Li on 10/15/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import Cocoa


enum SavedDataTableIdentifiers: String {
    case dataType = "dataTypeIdentifier"
    case value = "valueIdentifier"
}

class SavedDataViewModel: NSObject {
    let frc = SavedData.fetchedResultsController
    
    override init() {
        super.init()
    }
    
    func fetchInitialData() {
        try? frc.performFetch()
    }

}
