//
//  SavedDataViewController.swift
//  DuetMonitor
//
//  Created by Jing Wei Li on 10/15/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import Cocoa

class SavedDataViewController: NSViewController {
    @IBOutlet weak var tableView: NSTableView!
    
    let viewModel = SavedDataViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.target = self
        tableView.doubleAction = #selector(doubleClicked(_:))
    }
    
    @objc func doubleClicked(_ sender: AnyObject) {
        let data = viewModel.data[tableView.selectedRow]
        if let url = URL(string: "http://\(data.value)"), data.name == "IP Address" {
            NSWorkspace.shared.open(url)
        }
    }
    
}


// MARK: - Extensions
extension SavedDataViewController: NSTableViewDataSource, NSTableViewDelegate {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return viewModel.data.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let data = viewModel.data[row]
        var text: String = ""
        var identifier: SavedDataTableIdentifiers = .dataType
        if tableColumn == tableView.tableColumns[0] {
            identifier = .dataType
            text = data.name
        } else {
            identifier = .value
            text = data.value
        }
        
        if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: identifier.rawValue), owner: nil) as? NSTableCellView {
            cell.textField?.stringValue = text
            return cell
        }
        
        return nil
    }
    
}
