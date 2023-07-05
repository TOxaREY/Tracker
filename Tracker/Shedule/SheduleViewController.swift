//
//  SheduleViewController.swift
//  Tracker
//
//  Created by Anton Reynikov on 18.05.2023.
//

import UIKit

final class SheduleViewController: UIViewController {
    weak var delegateDataSource: DataSourceDelegate?
    private var nameTrackerTextField: UITextField?
    private var readyButton: UIButton?
    private var tableView: UITableView?
    private var dataSource: TableViewStaticDataSource!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Расписание"
        configureViews()
        addSubviews()
        makeConstraints()
    }
    
    private func configureViews() {
        self.view.backgroundColor = .ypWhite
        
        let readyButton = UIButton()
        readyButton.setTitle("Готово", for: .normal)
        readyButton.layer.cornerRadius = 16
        readyButton.clipsToBounds = true
        readyButton.backgroundColor = .ypBlack
        readyButton.titleLabel?.font = .ypMedium_16
        readyButton.titleLabel?.textAlignment = .center
        readyButton.setTitleColor(.ypWhite, for: .normal)
        readyButton.addTarget(self, action: #selector(didReadyButton), for: .touchUpInside)
        readyButton.translatesAutoresizingMaskIntoConstraints = false
        self.readyButton = readyButton
        
        let tableView = UITableView()
        var titles: [String] = []
        WeekDay.allCases.forEach { day in
            titles.append(day.rawValue)
        }
        dataSource = TableViewStaticDataSource(cells: titles.enumerated().map { SheduleTableViewCell(title: $1, index: $0, creationHabit: delegateDataSource?.creationEvent ?? CreationEvent()) })
        tableView.dataSource = dataSource
        tableView.backgroundColor = .clear
        tableView.rowHeight = 75.0
        tableView.separatorInset = .init(top: 0, left: 16.0, bottom: 0, right: 16.0)
        tableView.separatorColor = .ypGray
        tableView.layer.cornerRadius = 16.0
        tableView.layer.masksToBounds = true
        tableView.bounces = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        self.tableView = tableView
    }
    
    private func addSubviews() {
        view.addSubview(readyButton ?? UIButton())
        view.addSubview(tableView ?? UITableView())
    }
    
    private func makeConstraints() {
        NSLayoutConstraint.activate([
            tableView!.heightAnchor.constraint(equalToConstant: 525),
            tableView!.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            tableView!.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            tableView!.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            readyButton!.heightAnchor.constraint(equalToConstant: 60),
            readyButton!.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            readyButton!.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            readyButton!.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
    }
    
    @objc func didReadyButton() {
        delegateDataSource?.setDataSource()
        self.dismiss(animated: true)
    }
}

