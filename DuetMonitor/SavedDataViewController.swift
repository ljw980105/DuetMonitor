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
        
        viewModel.fetchInitialData()
        viewModel.frc.delegate = self
    }
    
    @objc func doubleClicked(_ sender: AnyObject) {
        let data = viewModel.frc.object(at: IndexPath(item: tableView.selectedRow, section: 0))
        if let val = data.value, let url = URL(string: "http://\(val)"), data.type == "IP Address" {
            NSWorkspace.shared.open(url)
        }
    }
    
}


// MARK: - Extensions
extension SavedDataViewController: NSTableViewDataSource, NSTableViewDelegate {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return viewModel.frc.fetchedObjects?.count ?? 0
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let data = viewModel.frc.object(at: IndexPath(item: row, section: 0))
        var text: String? = ""
        var identifier: SavedDataTableIdentifiers = .dataType
        if tableColumn == tableView.tableColumns[0] {
            identifier = .dataType
            text = data.type
        } else {
            identifier = .value
            text = data.value
        }
        
        if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: identifier.rawValue), owner: nil) as? NSTableCellView {
            cell.textField?.stringValue = text ?? ""
            return cell
        }
        
        return nil
    }
    
}

extension SavedDataViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        if type == .insert, let newIndexPath = newIndexPath {
            tableView.insertRows(at: IndexSet(arrayLiteral: newIndexPath.item), withAnimation: .slideLeft)
        }
        if type == .update, let newIndexPath = newIndexPath {
            tableView.reloadData(forRowIndexes: IndexSet(arrayLiteral: newIndexPath.item), columnIndexes: IndexSet(arrayLiteral: 0))
            tableView.reloadData(forRowIndexes: IndexSet(arrayLiteral: newIndexPath.item), columnIndexes: IndexSet(arrayLiteral: 1))
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}
