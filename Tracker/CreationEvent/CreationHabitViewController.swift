//
//  CreationHabitViewController.swift
//  Tracker
//
//  Created by Anton Reynikov on 18.05.2023.
//

import UIKit

final class CreationHabitViewController: UIViewController {
    var creationEvent = CreationEvent()
    weak var delegateTrackers: TrackersViewControllerDelegate?
    private var scrollView: UIScrollView?
    private var container: UIView?
    private var containerHeightAnchorConstraint: NSLayoutConstraint?
    private var nameTrackerTextField: UITextField?
    private var limitSimbolLabel: UILabel?
    private var isLimitSimbol = false
    private var clearButton: UIButton?
    private var dataSource: TableViewStaticDataSource!
    private var tableView: UITableView?
    private var tableViewTopAnchorConstraint: NSLayoutConstraint?
    private var emojiLabel: UILabel?
    private var emojiesCollectionView: UICollectionView?
    private let emojies = emojiesArray
    private var colorLabel: UILabel?
    private var colorsCollectionView: UICollectionView?
    private let colors = colorsArray
    private let params = GeometricParams(cellCount: 6,
                                                leftInset: 19,
                                                rightInset: 19,
                                                topInset: 24,
                                                bottomInset: 24,
                                                cellSpacing: 5)
    private var cancelButton: UIButton?
    private var createButton: UIButton?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Новая привычка"
        addCategory()
        configureViews()
        addSubviews()
        makeConstraints()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (touches.first) != nil {
            view.endEditing(true)
        }
        super.touchesBegan(touches, with: event)
    }
    
    private func configureViews() {
        self.view.backgroundColor = .ypWhite
        
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .ypWhite
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.scrollView = scrollView
        
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        self.container = container
        
        let nameTrackerTextField = UITextField()
        nameTrackerTextField.delegate = self
        nameTrackerTextField.attributedPlaceholder = NSAttributedString(string: "Введите название трекера", attributes: [NSAttributedString.Key.foregroundColor: UIColor.ypGray])
        nameTrackerTextField.backgroundColor = UIColor(hex: "#e6e8eb4d")
        nameTrackerTextField.font = .ypRegular_17
        nameTrackerTextField.textColor = .ypBlack
        nameTrackerTextField.layer.cornerRadius = 16.0
        nameTrackerTextField.layer.masksToBounds = true
        let lfView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 75))
        nameTrackerTextField.leftViewMode = .always
        nameTrackerTextField.leftView = lfView
        let rgView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 75))
        let btnClear = UIButton(type: .custom)
        btnClear.addTarget(self, action: #selector(didClearButton), for: .touchUpInside)
        btnClear.frame = CGRect(x: 17, y: 29, width: 17, height: 17)
        btnClear.setImage(UIImage(named: "clear"), for: .normal)
        btnClear.isHidden = true
        rgView.addSubview(btnClear)
        nameTrackerTextField.rightViewMode = .always
        nameTrackerTextField.rightView = rgView
        nameTrackerTextField.returnKeyType = .go
        nameTrackerTextField.translatesAutoresizingMaskIntoConstraints = false
        self.clearButton = btnClear
        self.nameTrackerTextField = nameTrackerTextField
        
        let limitSimbolLabel = UILabel()
        limitSimbolLabel.text = "Ограничение 38 символов"
        limitSimbolLabel.textColor = .ypRed
        limitSimbolLabel.textAlignment = .center
        limitSimbolLabel.font = .ypRegular_17
        limitSimbolLabel.isHidden = true
        limitSimbolLabel.translatesAutoresizingMaskIntoConstraints = false
        self.limitSimbolLabel = limitSimbolLabel
        
        let tableView = UITableView()
        tableView.delegate = self
        tableView.backgroundColor = .clear
        tableView.rowHeight = 75.0
        tableView.separatorInset = .init(top: 0, left: 16.0, bottom: 0, right: 16.0)
        tableView.separatorColor = .ypGray
        tableView.layer.cornerRadius = 16.0
        tableView.layer.masksToBounds = true
        tableView.translatesAutoresizingMaskIntoConstraints = false
        self.tableView = tableView
        setDataSource()
        
        let emojiLabel = UILabel()
        emojiLabel.text = "Emoji"
        emojiLabel.textColor = .ypBlack
        emojiLabel.textAlignment = .left
        emojiLabel.font = .ypBold_19
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        self.emojiLabel = emojiLabel
        
        let emojiesCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        emojiesCollectionView.tag = 1
        emojiesCollectionView.dataSource = self
        emojiesCollectionView.delegate = self
        emojiesCollectionView.register(EmojiCollectionViewCell.self, forCellWithReuseIdentifier: "emojiCell")
        emojiesCollectionView.backgroundColor = .ypWhite
        emojiesCollectionView.allowsMultipleSelection = false
        emojiesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        self.emojiesCollectionView = emojiesCollectionView
        
        let colorLabel = UILabel()
        colorLabel.text = "Цвет"
        colorLabel.textColor = .ypBlack
        colorLabel.textAlignment = .left
        colorLabel.font = .ypBold_19
        colorLabel.translatesAutoresizingMaskIntoConstraints = false
        self.colorLabel = colorLabel
        
        let colorsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        colorsCollectionView.tag = 2
        colorsCollectionView.dataSource = self
        colorsCollectionView.delegate = self
        colorsCollectionView.register(ColorCollectionViewCell.self, forCellWithReuseIdentifier: "colorCell")
        colorsCollectionView.backgroundColor = .ypWhite
        colorsCollectionView.allowsMultipleSelection = false
        colorsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        self.colorsCollectionView = colorsCollectionView
        
        let cancelButton = UIButton()
        cancelButton.setTitle("Отменить", for: .normal)
        cancelButton.layer.cornerRadius = 16
        cancelButton.clipsToBounds = true
        cancelButton.backgroundColor = .ypWhite
        cancelButton.titleLabel?.font = .ypMedium_16
        cancelButton.titleLabel?.textAlignment = .center
        cancelButton.setTitleColor(.ypRed, for: .normal)
        cancelButton.layer.borderWidth = CGFloat(1)
        cancelButton.layer.borderColor = UIColor.ypRed.cgColor
        cancelButton.addTarget(self, action: #selector(didCancelButton), for: .touchUpInside)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        self.cancelButton = cancelButton
        
        let createButton = UIButton()
        createButton.setTitle("Создать", for: .normal)
        createButton.layer.cornerRadius = 16
        createButton.clipsToBounds = true
        createButton.backgroundColor = .ypGray
        createButton.titleLabel?.font = .ypMedium_16
        createButton.titleLabel?.textAlignment = .center
        createButton.setTitleColor(.ypWhite, for: .normal)
        createButton.addTarget(self, action: #selector(didCreateButton), for: .touchUpInside)
        createButton.translatesAutoresizingMaskIntoConstraints = false
        createButton.isEnabled = false
        self.createButton = createButton
    }
    
    private func addSubviews() {
        view.addSubview(scrollView ?? UIScrollView())
        container?.addSubview(nameTrackerTextField ?? UITextField())
        container?.addSubview(limitSimbolLabel ?? UILabel())
        container?.addSubview(tableView ?? UITableView())
        container?.addSubview(emojiLabel ?? UILabel())
        container?.addSubview(emojiesCollectionView ?? UICollectionView())
        container?.addSubview(colorLabel ?? UILabel())
        container?.addSubview(colorsCollectionView ?? UICollectionView())
        scrollView?.addSubview(container ?? UIView())
        view.addSubview(cancelButton ?? UIButton())
        view.addSubview(createButton ?? UIButton())
    }
    
    private func makeConstraints() {
        containerHeightAnchorConstraint = container?.heightAnchor.constraint(equalToConstant: 781)
        tableViewTopAnchorConstraint = tableView?.topAnchor.constraint(equalTo: nameTrackerTextField!.bottomAnchor, constant: 24)
        NSLayoutConstraint.activate([
            scrollView!.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView!.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView!.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView!.bottomAnchor.constraint(equalTo: cancelButton!.topAnchor, constant: -16),
            container!.topAnchor.constraint(equalTo: scrollView!.topAnchor),
            container!.bottomAnchor.constraint(equalTo: scrollView!.bottomAnchor),
            container!.leadingAnchor.constraint(equalTo: scrollView!.leadingAnchor),
            container!.trailingAnchor.constraint(equalTo: scrollView!.trailingAnchor),
            container!.widthAnchor.constraint(equalTo: scrollView!.widthAnchor),
            containerHeightAnchorConstraint!,
            nameTrackerTextField!.heightAnchor.constraint(equalToConstant: 75),
            nameTrackerTextField!.topAnchor.constraint(equalTo: container!.topAnchor, constant: 24),
            nameTrackerTextField!.leadingAnchor.constraint(equalTo: container!.leadingAnchor, constant: 16),
            nameTrackerTextField!.trailingAnchor.constraint(equalTo: container!.trailingAnchor, constant: -16),
            limitSimbolLabel!.topAnchor.constraint(equalTo: nameTrackerTextField!.bottomAnchor, constant: 8),
            limitSimbolLabel!.centerXAnchor.constraint(equalTo: container!.centerXAnchor),
            tableView!.heightAnchor.constraint(equalToConstant: 150),
            tableViewTopAnchorConstraint!,
            tableView!.leadingAnchor.constraint(equalTo: container!.leadingAnchor, constant: 16),
            tableView!.trailingAnchor.constraint(equalTo: container!.trailingAnchor, constant: -16),
            emojiLabel!.topAnchor.constraint(equalTo: tableView!.bottomAnchor, constant: 32),
            emojiLabel!.leadingAnchor.constraint(equalTo: container!.leadingAnchor, constant: 28),
            emojiesCollectionView!.topAnchor.constraint(equalTo: emojiLabel!.bottomAnchor),
            emojiesCollectionView!.leadingAnchor.constraint(equalTo: container!.leadingAnchor),
            emojiesCollectionView!.trailingAnchor.constraint(equalTo: container!.trailingAnchor),
            emojiesCollectionView!.heightAnchor.constraint(equalToConstant: 204),
            colorLabel!.topAnchor.constraint(equalTo: emojiesCollectionView!.bottomAnchor, constant: 16),
            colorLabel!.leadingAnchor.constraint(equalTo: container!.leadingAnchor, constant: 28),
            colorsCollectionView!.topAnchor.constraint(equalTo: colorLabel!.bottomAnchor),
            colorsCollectionView!.leadingAnchor.constraint(equalTo: container!.leadingAnchor),
            colorsCollectionView!.trailingAnchor.constraint(equalTo: container!.trailingAnchor),
            colorsCollectionView!.heightAnchor.constraint(equalToConstant: 204),
            cancelButton!.heightAnchor.constraint(equalToConstant: 60),
            cancelButton!.widthAnchor.constraint(equalToConstant: 161),
            cancelButton!.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            cancelButton!.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            createButton!.heightAnchor.constraint(equalToConstant: 60),
            createButton!.widthAnchor.constraint(equalToConstant: 161),
            createButton!.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            createButton!.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
    }
    
    private func checkAllFillField() {
        if creationEvent.name != "" && creationEvent.category != "" && creationEvent.sheduleString() != "" && creationEvent.emoji != "" && creationEvent.color != nil && !isLimitSimbol {
            createButton?.backgroundColor = .ypBlack
            createButton?.isEnabled = true
        } else {
            createButton?.backgroundColor = .ypGray
            createButton?.isEnabled = false
        }
    }
    
    private func addTracker() {
        guard let categories = delegateTrackers?.categories else { return }
        let oldCategories = categories
        var newCategories: [TrackerCategory] = []
        for category in oldCategories {
            if category.title == creationEvent.category {
                var newTrackers = category.trackers
                newTrackers.append(Tracker(id: UUID().uuidString, name: creationEvent.name, color: creationEvent.color!, emoji: creationEvent.emoji, shedule: creationEvent.shedule))
                newCategories.append(TrackerCategory(title: creationEvent.category, trackers: newTrackers))
            } else {
                newCategories.append(category)
            }
        }
        if !newCategories.contains(where: { $0.title == creationEvent.category }) {
            newCategories.append(TrackerCategory(title: creationEvent.category, trackers: [Tracker(id: UUID().uuidString, name: creationEvent.name, color: creationEvent.color!, emoji: creationEvent.emoji, shedule: creationEvent.shedule)]))
        }
        delegateTrackers?.categories = newCategories
    }
    
    private func addCategory() {
        guard let category = delegateTrackers?.categories else { return }
        for cat in category {
            creationEvent.categoryArray.append((title: cat.title, isChecked: false))
        }
    }
    
    @objc func didCancelButton() {
        self.dismiss(animated: true)
    }
    
    @objc func didCreateButton() {
        addTracker()
        delegateTrackers?.checkDateAndReloadTrackersCollectionView()
        self.dismiss(animated: true)
    }
    
    @objc func didClearButton() {
        nameTrackerTextField?.text = ""
        isLimitSimbol = false
        setLimitSimbolLabel()
    }
}

extension CreationHabitViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let categoryVC = CategoryViewController()
            categoryVC.delegateDataSource = self
            let navVC = UINavigationController(rootViewController: categoryVC)
            navVC.modalPresentationStyle = .automatic
            present(navVC, animated: true)
        } else {
            let sheduleVC = SheduleViewController()
            sheduleVC.delegateDataSource = self
            let navVC = UINavigationController(rootViewController: sheduleVC)
            navVC.modalPresentationStyle = .automatic
            present(navVC, animated: true)
        }
    }
}

extension CreationHabitViewController: DataSourceDelegate {
    func setDataSource() {
        let items: [(title: String, subtitle: String)] = [
            ("Категория", creationEvent.category),
            ("Расписание", creationEvent.sheduleString())
        ]
        dataSource = TableViewStaticDataSource(cells: items.map { CreationTableViewCell(title: $0.title, subtitle: $0.subtitle) })
        tableView?.dataSource = dataSource
        tableView?.reloadData()
        checkAllFillField()
    }
}

extension CreationHabitViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var number = Int()
        if collectionView.tag == 1 {
            number = emojies.count
        } else if collectionView.tag == 2 {
            number = colors.count
        }
        return number
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        if collectionView.tag == 1 {
            let cellEmoji = collectionView.dequeueReusableCell(withReuseIdentifier: "emojiCell", for: indexPath) as? EmojiCollectionViewCell
            cellEmoji?.label.text = emojies[indexPath.row]
            cell = cellEmoji!
        } else if collectionView.tag == 2 {
            let cellColor = collectionView.dequeueReusableCell(withReuseIdentifier: "colorCell", for: indexPath) as? ColorCollectionViewCell
            cellColor?.colorView.backgroundColor = colors[indexPath.row]
            cellColor?.view.layer.borderColor = UIColor.clear.cgColor
            cell = cellColor!
        }
        return cell
    }
}

extension CreationHabitViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellSize = setCellSize(collectionView)
        return CGSize(width: cellSize, height: cellSize)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: params.topInset, left: params.leftInset, bottom: params.bottomInset, right: params.rightInset)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        let cellSize = setCellSize(collectionView)
        return (204 - cellSize * 3 - params.topInset - params.bottomInset) / 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return params.cellSpacing
    }
    
    private func setCellSize(_ collectionView: UICollectionView) -> CGFloat {
        let availableWidth = collectionView.frame.width - params.paddingWight
        let cellSize = availableWidth / CGFloat(params.cellCount)
        
        return cellSize
    }
}

extension CreationHabitViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.tag == 1 {
            let cell = collectionView.cellForItem(at: indexPath) as? EmojiCollectionViewCell
            cell?.view.backgroundColor = .ypLightGray
            creationEvent.emoji = emojies[indexPath.row]
        } else if collectionView.tag == 2 {
            let cell = collectionView.cellForItem(at: indexPath) as? ColorCollectionViewCell
            cell?.view.layer.borderColor = colors[indexPath.row]?.withAlphaComponent(0.30).cgColor
            creationEvent.color = colors[indexPath.row]!
        }
        checkAllFillField()
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if collectionView.tag == 1 {
            let cell = collectionView.cellForItem(at: indexPath) as? EmojiCollectionViewCell
            cell?.view.backgroundColor = .clear
        } else if collectionView.tag == 2 {
            let cell = collectionView.cellForItem(at: indexPath) as? ColorCollectionViewCell
            cell?.view.layer.borderColor = UIColor.clear.cgColor
        }
    }
}

extension CreationHabitViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField.text != "" {
            clearButton?.isHidden = false
            if textField.text!.count >= 38 && !isLimitSimbol {
                textField.text?.removeLast()
                isLimitSimbol = true
                setLimitSimbolLabel()
            } else if textField.text!.count < 38 && isLimitSimbol {
                isLimitSimbol = false
                setLimitSimbolLabel()
            }
        } else {
            clearButton?.isHidden = true
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        if textField.text != "" {
            creationEvent.name = textField.text!
        } else {
            creationEvent.name = ""
        }
        clearButton?.isHidden = true
        checkAllFillField()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    private func setLimitSimbolLabel() {
        if isLimitSimbol {
            limitSimbolLabel?.isHidden = false
            containerHeightAnchorConstraint?.isActive = false
            tableViewTopAnchorConstraint?.isActive = false
            containerHeightAnchorConstraint = container?.heightAnchor.constraint(equalToConstant: 819)
            tableViewTopAnchorConstraint = tableView?.topAnchor.constraint(equalTo: nameTrackerTextField!.bottomAnchor, constant: 62)
            containerHeightAnchorConstraint?.isActive = true
            tableViewTopAnchorConstraint?.isActive = true
        } else {
            limitSimbolLabel?.isHidden = true
            containerHeightAnchorConstraint?.isActive = false
            tableViewTopAnchorConstraint?.isActive = false
            containerHeightAnchorConstraint = container?.heightAnchor.constraint(equalToConstant: 781)
            tableViewTopAnchorConstraint = tableView?.topAnchor.constraint(equalTo: nameTrackerTextField!.bottomAnchor, constant: 24)
            containerHeightAnchorConstraint?.isActive = true
            tableViewTopAnchorConstraint?.isActive = true
        }
    }
}
