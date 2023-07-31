//
//  CategoryViewController.swift
//  Tracker
//
//  Created by Anton Reynikov on 19.05.2023.
//

import UIKit

final class CategoryViewController: UIViewController {
    weak var delegateDataSource: DataSourceDelegate?
    private let trackerCategoryStore = TrackerCategoryStore()
    private let maxHeightTableView = Int(UIScreen.main.bounds.height - 286)
    private var viewModel: CategoryViewModel!
    private var dataSource: TableViewStaticDataSource!
    private lazy var combinedHabitsEventsImageView: UIImageView = {
        let combinedHabitsEventsImage = UIImage(named: "stars")
        let combinedHabitsEventsImageView = UIImageView(image: combinedHabitsEventsImage)
        combinedHabitsEventsImageView.contentMode = .scaleAspectFit
        combinedHabitsEventsImageView.translatesAutoresizingMaskIntoConstraints = false
        return combinedHabitsEventsImageView
    }()
    
    private lazy var combinedHabitsEventsLabel: UILabel = {
        let combinedHabitsEventsLabel = UILabel()
        combinedHabitsEventsLabel.numberOfLines = 0
        combinedHabitsEventsLabel.text = "Привычки и события можно\nобъединить по смыслу"
        combinedHabitsEventsLabel.textColor = .ypBlack
        combinedHabitsEventsLabel.textAlignment = .center
        combinedHabitsEventsLabel.font = .ypMedium_12
        combinedHabitsEventsLabel.translatesAutoresizingMaskIntoConstraints = false
        return combinedHabitsEventsLabel
    }()
    
    private lazy var addCategoryButton: UIButton = {
        let addCategoryButton = UIButton()
        addCategoryButton.setTitle("Добавить категорию", for: .normal)
        addCategoryButton.layer.cornerRadius = 16
        addCategoryButton.clipsToBounds = true
        addCategoryButton.backgroundColor = .ypBlack
        addCategoryButton.titleLabel?.font = .ypMedium_16
        addCategoryButton.titleLabel?.textAlignment = .center
        addCategoryButton.setTitleColor(.ypWhite, for: .normal)
        addCategoryButton.addTarget(
            self,
            action: #selector(didAddCategoryButton),
            for: .touchUpInside
        )
        addCategoryButton.translatesAutoresizingMaskIntoConstraints = false
        return addCategoryButton
    }()
    
    private lazy var tableView: UITableView = {
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
        return tableView
    }()
    
    private var heightTableViewConstraint: NSLayoutConstraint?
    private var bottomAnchorTableViewConstraint: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .ypWhite
        self.title = "Категория"
        addSubviews()
        makeConstraints()
        viewModel = CategoryViewModel(delegateDataSource: delegateDataSource)
        viewModel.$categories.bind { [weak self] _ in
            guard let self = self else { return }
            self.setTableView()
        }
        setTableView()
    }
    
    private func addSubviews() {
        view.addSubview(combinedHabitsEventsImageView)
        view.addSubview(combinedHabitsEventsLabel)
        view.addSubview(tableView)
        view.addSubview(addCategoryButton)
    }
    
    private func makeConstraints() {
        NSLayoutConstraint.activate([
            combinedHabitsEventsImageView.widthAnchor.constraint(equalToConstant: 80),
            combinedHabitsEventsImageView.heightAnchor.constraint(equalToConstant: 80),
            combinedHabitsEventsImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 232),
            combinedHabitsEventsImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            combinedHabitsEventsLabel.topAnchor.constraint(equalTo: combinedHabitsEventsImageView.bottomAnchor, constant: 8),
            combinedHabitsEventsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 38),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            addCategoryButton.heightAnchor.constraint(equalToConstant: 60),
            addCategoryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            addCategoryButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            addCategoryButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
    }
    
    @objc private func didAddCategoryButton() {
        let newCategoryVC = NewCategoryViewController()
        let navVC = UINavigationController(rootViewController: newCategoryVC)
        navVC.modalPresentationStyle = .automatic
        present(navVC, animated: true)
    }
    
    private func setTableView() {
        if viewModel.categoriesIsNotEmpty() {
            combinedHabitsEventsImageView.isHidden = true
            combinedHabitsEventsLabel.isHidden = true
        }
        if viewModel.categoriesCount() * 75 <= maxHeightTableView {
            heightTableViewConstraint?.isActive = false
            bottomAnchorTableViewConstraint?.isActive = false
            heightTableViewConstraint = tableView.heightAnchor.constraint(equalToConstant: CGFloat(viewModel.categoriesCount() * 75))
            heightTableViewConstraint?.isActive = true
        } else {
            heightTableViewConstraint?.isActive = false
            bottomAnchorTableViewConstraint = tableView.bottomAnchor.constraint(equalTo: self.addCategoryButton.topAnchor, constant: -38)
            bottomAnchorTableViewConstraint?.isActive = true
        }
        
        dataSource = viewModel.setDataSource()
        
        tableView.dataSource = dataSource
        tableView.reloadData()
    }
}

extension CategoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectRowTableView(index: indexPath.row)
        self.dismiss(animated: true)
    }
}

