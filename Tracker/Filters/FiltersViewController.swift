//
//  FiltersViewController.swift
//  Tracker
//
//  Created by Anton Reynikov on 01.08.2023.
//

import UIKit

final class FiltersViewController: UIViewController {
    weak var delegateFilters: FiltersDelegate?
    private var dataSource: TableViewStaticDataSource!
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        var filters: [(title: String, isChecked: Bool)] = []
        FiltersName.allCases.forEach { filter in
            filters.append((title: filter.name, isChecked: false))
        }
        filters[delegateFilters?.filtersName.rawValue ?? 0].isChecked = true
        dataSource = TableViewStaticDataSource(
            cells: filters.map {
                ListTableViewCell(
                    title: $0.title,
                    isChecked: $0.isChecked
                )
            }
        )
        tableView.dataSource = dataSource
        tableView.backgroundColor = .clear
        tableView.rowHeight = 75.0
        tableView.separatorInset = .init(top: 0, left: 16.0, bottom: 0, right: 16.0)
        tableView.separatorColor = .ypGray
        tableView.layer.cornerRadius = 16.0
        tableView.layer.masksToBounds = true
        tableView.bounces = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .ypWhite
        self.title = NSLocalizedString(
            "filters.title",
            comment: "Title filters"
        )
        addSubviews()
        makeConstraints()
    }
    
    private func addSubviews() {
        view.addSubview(tableView)
    }
    
    private func makeConstraints() {
        NSLayoutConstraint.activate([
            tableView.heightAnchor.constraint(equalToConstant: 300),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
        ])
    }
}

extension FiltersViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegateFilters?.filtersName = FiltersName(rawValue: indexPath.row) ?? FiltersName.AllTrackers
        self.dismiss(animated: true)
    }
}
