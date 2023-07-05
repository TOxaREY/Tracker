//
//  CategoryViewController.swift
//  Tracker
//
//  Created by Anton Reynikov on 19.05.2023.
//

import UIKit

final class CategoryViewController: UIViewController {
    let maxHeightTableView = Int(UIScreen.main.bounds.height - 286)
    weak var delegateDataSource: DataSourceDelegate?
    private var combinedHabitsEventsImageView: UIImageView?
    private var combinedHabitsEventsLabel: UILabel?
    private var dataSource: TableViewStaticDataSource!
    private var addCategoryButton: UIButton?
    private var tableView: UITableView?
    private var heightTableViewConstraint: NSLayoutConstraint?
    private var bottomAnchorTableViewConstraint: NSLayoutConstraint?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Категория"
        configureViews()
        addSubviews()
        makeConstraints()
        setDataSource()
    }
    
    private func configureViews() {
        self.view.backgroundColor = .ypWhite
        
        let combinedHabitsEventsImage = UIImage(named: "stars")
        let combinedHabitsEventsImageView = UIImageView(image: combinedHabitsEventsImage)
        combinedHabitsEventsImageView.contentMode = .scaleAspectFit
        combinedHabitsEventsImageView.translatesAutoresizingMaskIntoConstraints = false
        self.combinedHabitsEventsImageView = combinedHabitsEventsImageView
        
        let combinedHabitsEventsLabel = UILabel()
        combinedHabitsEventsLabel.numberOfLines = 0
        combinedHabitsEventsLabel.text = "Привычки и события можно\nобъединить по смыслу"
        combinedHabitsEventsLabel.textColor = .ypBlack
        combinedHabitsEventsLabel.textAlignment = .center
        combinedHabitsEventsLabel.font = .ypMedium_12
        combinedHabitsEventsLabel.translatesAutoresizingMaskIntoConstraints = false
        self.combinedHabitsEventsLabel = combinedHabitsEventsLabel
        
        let tableView = UITableView()
        tableView.delegate = self
        tableView.backgroundColor = .clear
        tableView.rowHeight = 75.0
        tableView.separatorInset = .init(top: 0, left: 16.0, bottom: 0, right: 16.0)
        tableView.separatorColor = .ypGray
        tableView.layer.cornerRadius = 16.0
        tableView.layer.masksToBounds = true
        tableView.bounces = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        self.tableView = tableView
        
        let addCategoryButton = UIButton()
        addCategoryButton.setTitle("Добавить категорию", for: .normal)
        addCategoryButton.layer.cornerRadius = 16
        addCategoryButton.clipsToBounds = true
        addCategoryButton.backgroundColor = .ypBlack
        addCategoryButton.titleLabel?.font = .ypMedium_16
        addCategoryButton.titleLabel?.textAlignment = .center
        addCategoryButton.setTitleColor(.ypWhite, for: .normal)
        addCategoryButton.addTarget(self, action: #selector(didAddCategoryButton), for: .touchUpInside)
        addCategoryButton.translatesAutoresizingMaskIntoConstraints = false
        self.addCategoryButton = addCategoryButton
    }
    
    private func addSubviews() {
        view.addSubview(combinedHabitsEventsImageView ?? UIImageView())
        view.addSubview(combinedHabitsEventsLabel ?? UILabel())
        view.addSubview(tableView ?? UITableView())
        view.addSubview(addCategoryButton ?? UIButton())
    }
    
    private func makeConstraints() {
        NSLayoutConstraint.activate([
            combinedHabitsEventsImageView!.widthAnchor.constraint(equalToConstant: 80),
            combinedHabitsEventsImageView!.heightAnchor.constraint(equalToConstant: 80),
            combinedHabitsEventsImageView!.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 232),
            combinedHabitsEventsImageView!.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            combinedHabitsEventsLabel!.topAnchor.constraint(equalTo: combinedHabitsEventsImageView!.bottomAnchor, constant: 8),
            combinedHabitsEventsLabel!.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tableView!.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 38),
            tableView!.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            tableView!.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            addCategoryButton!.heightAnchor.constraint(equalToConstant: 60),
            addCategoryButton!.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            addCategoryButton!.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            addCategoryButton!.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
    }
    
    @objc func didAddCategoryButton() {
        let newCategoryVC = NewCategoryViewController()
        newCategoryVC.delegateDataSource = self
        let navVC = UINavigationController(rootViewController: newCategoryVC)
        navVC.modalPresentationStyle = .automatic
        present(navVC, animated: true)
    }
}

extension CategoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        creationEvent.checkedCategory(index: indexPath.row)
        creationEvent.category = creationEvent.categoryArray[indexPath.row].title
        delegateDataSource?.setDataSource()
        self.dismiss(animated: true)
    }
}

extension CategoryViewController: DataSourceDelegate {
    var creationEvent: CreationEvent {
        get {
            return delegateDataSource?.creationEvent ?? CreationEvent()
        }
        set {
            delegateDataSource?.creationEvent = newValue
        }
    }
    
    func setDataSource() {
        let items = creationEvent.categoryArray
        if !items.isEmpty {
            combinedHabitsEventsImageView?.isHidden = true
            combinedHabitsEventsLabel?.isHidden = true
        }
        dataSource = TableViewStaticDataSource(cells: items.map { CategoryTableViewCell(title: $0.title, isChecked: $0.isChecked) })
        if items.count * 75 <= maxHeightTableView {
            heightTableViewConstraint?.isActive = false
            bottomAnchorTableViewConstraint?.isActive = false
            heightTableViewConstraint = tableView?.heightAnchor.constraint(equalToConstant: CGFloat(items.count * 75))
            heightTableViewConstraint?.isActive = true
        } else {
            heightTableViewConstraint?.isActive = false
            bottomAnchorTableViewConstraint = tableView?.bottomAnchor.constraint(equalTo: self.addCategoryButton!.topAnchor, constant: -38)
            bottomAnchorTableViewConstraint?.isActive = true
        }
        
        tableView?.dataSource = dataSource
        tableView?.reloadData()
    }
}

