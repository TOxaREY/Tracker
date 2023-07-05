//
//  TableViewStaticDataSource.swift
//  Tracker
//
//  Created by Anton Reynikov on 18.05.2023.
//

import UIKit

final class TableViewStaticDataSource: NSObject, UITableViewDataSource {
    private let cells: [UITableViewCell]
    
    init(cells: [UITableViewCell]) {
        self.cells = cells
        super.init()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == cells.count - 1 {
            cells[indexPath.row].separatorInset = UIEdgeInsets(top: 0, left: tableView.bounds.width + 1, bottom: 0, right: 0)
        }
        return cells[indexPath.row]
    }
}
