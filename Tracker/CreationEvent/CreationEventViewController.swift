//
//  CreationEventViewController.swift
//  Tracker
//
//  Created by Anton Reynikov on 20.07.2023.
//

import UIKit

class CreationEventViewController: UIViewController, DataSourceDelegate {
    var creationEvent = CreationEvent()
    weak var delegateTrackers: TrackersViewControllerDelegate?
    var dataSource: TableViewStaticDataSource!
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.backgroundColor = .clear
        tableView.rowHeight = 75.0
        tableView.separatorInset = .init(top: 0, left: 16.0, bottom: 0, right: 16.0)
        tableView.separatorColor = .ypGray
        tableView.layer.cornerRadius = 16.0
        tableView.layer.masksToBounds = true
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    let trackerCategoryStore = TrackerCategoryStore()
    private let trackerRecordStore = TrackerRecordStore()
    private var isLimitSimbol = false
    private var containerHeightAnchorConstraint: NSLayoutConstraint?
    private lazy var container: UIView = {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        return container
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .ypWhite
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var numberOfDaysLabel: UILabel = {
        let numberOfDaysLabel = UILabel()
        numberOfDaysLabel.textColor = .ypBlack
        numberOfDaysLabel.textAlignment = .center
        numberOfDaysLabel.font = .ypBold_32
        numberOfDaysLabel.isHidden = true
        numberOfDaysLabel.translatesAutoresizingMaskIntoConstraints = false
        return numberOfDaysLabel
    }()
    
    private lazy var nameTrackerTextField: UITextField = {
        let nameTrackerTextField = UITextField()
        nameTrackerTextField.delegate = self
        nameTrackerTextField.attributedPlaceholder = NSAttributedString(
            string: NSLocalizedString(
                "nameTracker.placeholder",
                comment: "Placeholder name tracker"
            ),
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.ypGray]
        )
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
        return nameTrackerTextField
    }()
    
    private lazy var limitSimbolLabel: UILabel = {
        let limitSimbolLabel = UILabel()
        limitSimbolLabel.text = NSLocalizedString(
            "limitSimbol.message",
            comment: "Limit simbol message"
        )
        limitSimbolLabel.textColor = .ypRed
        limitSimbolLabel.textAlignment = .center
        limitSimbolLabel.font = .ypRegular_17
        limitSimbolLabel.isHidden = true
        limitSimbolLabel.translatesAutoresizingMaskIntoConstraints = false
        return limitSimbolLabel
    }()
    
    private var clearButton: UIButton?
    private var tableViewTopAnchorConstraint: NSLayoutConstraint?
    private var nameTrackerTextFieldTopAnchorConstraint: NSLayoutConstraint?
    private lazy var emojiLabel: UILabel = {
        let emojiLabel = UILabel()
        emojiLabel.text = "Emoji"
        emojiLabel.textColor = .ypBlack
        emojiLabel.textAlignment = .left
        emojiLabel.font = .ypBold_19
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        return emojiLabel
    }()
    
    private lazy var emojiesCollectionView: UICollectionView = {
        let emojiesCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        emojiesCollectionView.tag = 1
        emojiesCollectionView.dataSource = self
        emojiesCollectionView.delegate = self
        emojiesCollectionView.register(EmojiCollectionViewCell.self, forCellWithReuseIdentifier: "emojiCell")
        emojiesCollectionView.backgroundColor = .ypWhite
        emojiesCollectionView.allowsMultipleSelection = false
        emojiesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        return emojiesCollectionView
    }()
    
    private let emojies = emojiesArray
    private lazy var colorLabel: UILabel = {
        let colorLabel = UILabel()
        colorLabel.text = NSLocalizedString(
            "color.title",
            comment: "Title color"
        )
        colorLabel.textColor = .ypBlack
        colorLabel.textAlignment = .left
        colorLabel.font = .ypBold_19
        colorLabel.translatesAutoresizingMaskIntoConstraints = false
        return colorLabel
    }()
    
    private lazy var colorsCollectionView: UICollectionView = {
        let colorsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        colorsCollectionView.tag = 2
        colorsCollectionView.dataSource = self
        colorsCollectionView.delegate = self
        colorsCollectionView.register(ColorCollectionViewCell.self, forCellWithReuseIdentifier: "colorCell")
        colorsCollectionView.backgroundColor = .ypWhite
        colorsCollectionView.allowsMultipleSelection = false
        colorsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        return colorsCollectionView
    }()
    
    private let colors = colorsArray
    private let params = GeometricParams(cellCount: 6,
                                         leftInset: 19,
                                         rightInset: 19,
                                         topInset: 24,
                                         bottomInset: 24,
                                         cellSpacing: 5)
    private let cancelButton: UIButton = {
        let cancelButton = UIButton()
        cancelButton.setTitle(
            NSLocalizedString(
                "cancel",
                comment: "Title cancel button"
            ),
            for: .normal
        )
        cancelButton.layer.cornerRadius = 16
        cancelButton.clipsToBounds = true
        cancelButton.backgroundColor = .ypWhite
        cancelButton.titleLabel?.font = .ypMedium_16
        cancelButton.titleLabel?.textAlignment = .center
        cancelButton.setTitleColor(.ypRed, for: .normal)
        cancelButton.layer.borderWidth = CGFloat(1)
        cancelButton.layer.borderColor = UIColor.ypRed.cgColor
        cancelButton.addTarget(
            self,
            action: #selector(didCancelButton),
            for: .touchUpInside
        )
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        return cancelButton
    }()
    
    private let createButton: UIButton = {
        let createButton = UIButton()
        createButton.setTitle(
            NSLocalizedString(
                "create",
                comment: "Title create button"
            ),
            for: .normal
        )
        createButton.layer.cornerRadius = 16
        createButton.clipsToBounds = true
        createButton.backgroundColor = .ypGray
        createButton.titleLabel?.font = .ypMedium_16
        createButton.titleLabel?.textAlignment = .center
        createButton.setTitleColor(.ypWhite, for: .normal)
        createButton.addTarget(
            self,
            action: #selector(didCreateButton),
            for: .touchUpInside
        )
        createButton.translatesAutoresizingMaskIntoConstraints = false
        createButton.isEnabled = false
        return createButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .ypWhite
        addSubviews()
        makeConstraints()
        setDataSource()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (touches.first) != nil {
            view.endEditing(true)
        }
        super.touchesBegan(touches, with: event)
    }
    
    func setContainerAndTableViewHeight(containerHeight: CGFloat, tableViewHeight: CGFloat) {
        containerHeightAnchorConstraint = container.heightAnchor.constraint(equalToConstant: containerHeight)
        tableView.heightAnchor.constraint(equalToConstant: tableViewHeight).isActive = true
    }
    
    func checkAllFillField(isHabit: Bool) {
        if creationEvent.name != "" && creationEvent.categoryName != "" && !isHabit && creationEvent.emoji != "" && creationEvent.color != nil && !isLimitSimbol {
            createButton.backgroundColor = .ypBlack
            createButton.isEnabled = true
        } else {
            createButton.backgroundColor = .ypGray
            createButton.isEnabled = false
        }
    }
    
    func addTracker(shedule: [WeekDay]?) {
        trackerCategoryStore.addTracker(
            title: creationEvent.categoryName,
            tracker: Tracker(
                id: creationEvent.id,
                name: creationEvent.name,
                color: creationEvent.color!,
                emoji: creationEvent.emoji,
                shedule: shedule,
                fixed: false
            )
        )
    }
    
    func setDataSource() {
        let items: [(title: String, subtitle: String)] = [
            (
                NSLocalizedString(
                "category.title",
                comment: "Title category"
            ),
             creationEvent.categoryName
            ),
            (
                NSLocalizedString(
                    "shedule.title",
                    comment: "Title shedule"
                ),
             creationEvent.sheduleString()
            )
        ]
        dataSource = TableViewStaticDataSource(cells: items.map { CreationTableViewCell(title: $0.title, subtitle: $0.subtitle) })
        tableView.dataSource = dataSource
        tableView.reloadData()
        checkAllFillField(isHabit: creationEvent.sheduleString() == "")
    }
    
    func setLimitSimbolLabel(containerHeightLimitSimbol: CGFloat, containerHeightNotLimitSimbol: CGFloat) {
        if isLimitSimbol {
            limitSimbolLabel.isHidden = false
            containerHeightAnchorConstraint?.isActive = false
            tableViewTopAnchorConstraint?.isActive = false
            containerHeightAnchorConstraint = container.heightAnchor.constraint(equalToConstant: containerHeightLimitSimbol)
            tableViewTopAnchorConstraint = tableView.topAnchor.constraint(equalTo: nameTrackerTextField.bottomAnchor, constant: 62)
            containerHeightAnchorConstraint?.isActive = true
            tableViewTopAnchorConstraint?.isActive = true
        } else {
            limitSimbolLabel.isHidden = true
            containerHeightAnchorConstraint?.isActive = false
            tableViewTopAnchorConstraint?.isActive = false
            containerHeightAnchorConstraint = container.heightAnchor.constraint(equalToConstant: containerHeightNotLimitSimbol)
            tableViewTopAnchorConstraint = tableView.topAnchor.constraint(equalTo: nameTrackerTextField.bottomAnchor, constant: 24)
            containerHeightAnchorConstraint?.isActive = true
            tableViewTopAnchorConstraint?.isActive = true
        }
    }
    
    func setNameTrackerTextFieldConstraint() {
        nameTrackerTextFieldTopAnchorConstraint?.isActive = false
        nameTrackerTextFieldTopAnchorConstraint = nameTrackerTextField.topAnchor.constraint(equalTo: numberOfDaysLabel.bottomAnchor, constant: 40)
        nameTrackerTextFieldTopAnchorConstraint?.isActive = true
    }
    
    func setNumberOfDaysLabelText(id: UUID) {
        numberOfDaysLabel.isHidden = false
        numberOfDaysLabel.text = String.localizedStringWithFormat(
            NSLocalizedString(
                "numberOfDays",
                comment: "Number of completed days"
            ),
            trackerRecordStore.getCompletedTrackCount(id: id)
        )
    }
    
    func setNameTracker(name: String) {
        nameTrackerTextField.text = name
    }
    
    func setColorTracker(color: UIColor) {
        let indexPath = IndexPath(item: colors.firstIndex(of: color) ?? 0, section: 0)
        colorsCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: .top)
        let cell = colorsCollectionView.cellForItem(at: indexPath) as? ColorCollectionViewCell
        cell?.configureColorCollectionViewBorderColor(with: colors[indexPath.row]?.withAlphaComponent(0.30).cgColor)
    }
    
    func setEmojiTracker(emoji: String) {
        let indexPath = IndexPath(item: emojies.firstIndex(of: emoji) ?? 0, section: 0)
        emojiesCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: .top)
        let cell = emojiesCollectionView.cellForItem(at: indexPath) as? EmojiCollectionViewCell
        cell?.configureEmojiCollectionViewCellBackgroundColor(with: .ypLightGray)
    }
    
    func setNewTitleCreateButton() {
        createButton.setTitle(
            NSLocalizedString(
                "save",
                comment: "Title save button"
            ),
            for: .normal
        )
    }
    
    private func addSubviews() {
        view.addSubview(scrollView)
        container.addSubview(numberOfDaysLabel)
        container.addSubview(nameTrackerTextField)
        container.addSubview(limitSimbolLabel)
        container.addSubview(tableView)
        container.addSubview(emojiLabel)
        container.addSubview(emojiesCollectionView)
        container.addSubview(colorLabel)
        container.addSubview(colorsCollectionView)
        scrollView.addSubview(container)
        view.addSubview(cancelButton)
        view.addSubview(createButton)
    }
    
    private func makeConstraints() {
        setContainerAndTableViewHeight(containerHeight: 781, tableViewHeight: 150)
        tableViewTopAnchorConstraint = tableView.topAnchor.constraint(equalTo: nameTrackerTextField.bottomAnchor, constant: 24)
        nameTrackerTextFieldTopAnchorConstraint = nameTrackerTextField.topAnchor.constraint(equalTo: container.topAnchor, constant: 24)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: cancelButton.topAnchor, constant: -16),
            container.topAnchor.constraint(equalTo: scrollView.topAnchor),
            container.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            container.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            container.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            containerHeightAnchorConstraint ?? NSLayoutConstraint(),
            numberOfDaysLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 24),
            numberOfDaysLabel.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            nameTrackerTextField.heightAnchor.constraint(equalToConstant: 75),
            nameTrackerTextFieldTopAnchorConstraint ?? NSLayoutConstraint(),
            nameTrackerTextField.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            nameTrackerTextField.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
            limitSimbolLabel.topAnchor.constraint(equalTo: nameTrackerTextField.bottomAnchor, constant: 8),
            limitSimbolLabel.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            tableViewTopAnchorConstraint ?? NSLayoutConstraint(),
            tableView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
            emojiLabel.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 32),
            emojiLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 28),
            emojiesCollectionView.topAnchor.constraint(equalTo: emojiLabel.bottomAnchor),
            emojiesCollectionView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            emojiesCollectionView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            emojiesCollectionView.heightAnchor.constraint(equalToConstant: 204),
            colorLabel.topAnchor.constraint(equalTo: emojiesCollectionView.bottomAnchor, constant: 16),
            colorLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 28),
            colorsCollectionView.topAnchor.constraint(equalTo: colorLabel.bottomAnchor),
            colorsCollectionView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            colorsCollectionView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            colorsCollectionView.heightAnchor.constraint(equalToConstant: 204),
            cancelButton.heightAnchor.constraint(equalToConstant: 60),
            cancelButton.widthAnchor.constraint(equalToConstant: 161),
            cancelButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            cancelButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            createButton.heightAnchor.constraint(equalToConstant: 60),
            createButton.widthAnchor.constraint(equalToConstant: 161),
            createButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            createButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
    }
    
    @objc private func didCancelButton() {
        self.dismiss(animated: true)
    }
    
    @objc private func didCreateButton() {
        addTracker(shedule: creationEvent.shedule)
        delegateTrackers?.checkDateAndReloadTrackersCollectionView()
        self.dismiss(animated: true)
    }
    
    @objc private func didClearButton() {
        nameTrackerTextField.text = ""
        isLimitSimbol = false
        setLimitSimbolLabel(containerHeightLimitSimbol: 819, containerHeightNotLimitSimbol: 781)
    }
}

extension CreationEventViewController: UITableViewDelegate {
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

extension CreationEventViewController: UICollectionViewDataSource {
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
            cellEmoji?.configureEmojiCollectionViewCellLabel(with: emojies[indexPath.row])
            cell = cellEmoji!
        } else if collectionView.tag == 2 {
            let cellColor = collectionView.dequeueReusableCell(withReuseIdentifier: "colorCell", for: indexPath) as? ColorCollectionViewCell
            cellColor?.configureEmojiCollectionViewCellBackgroundColor(with: colors[indexPath.row]!)
            cellColor?.configureColorCollectionViewBorderColor(with: UIColor.clear.cgColor)
            cell = cellColor!
        }
        return cell
    }
}

extension CreationEventViewController: UICollectionViewDelegateFlowLayout {
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

extension CreationEventViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.tag == 1 {
            let cell = collectionView.cellForItem(at: indexPath) as? EmojiCollectionViewCell
            cell?.configureEmojiCollectionViewCellBackgroundColor(with: .ypLightGray)
            creationEvent.emoji = emojies[indexPath.row]
        } else if collectionView.tag == 2 {
            let cell = collectionView.cellForItem(at: indexPath) as? ColorCollectionViewCell
            cell?.configureColorCollectionViewBorderColor(with: colors[indexPath.row]?.withAlphaComponent(0.30).cgColor)
            creationEvent.color = colors[indexPath.row]!
        }
        checkAllFillField(isHabit: creationEvent.sheduleString() == "")
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if collectionView.tag == 1 {
            let cell = collectionView.cellForItem(at: indexPath) as? EmojiCollectionViewCell
            cell?.configureEmojiCollectionViewCellBackgroundColor(with: .clear)
        } else if collectionView.tag == 2 {
            let cell = collectionView.cellForItem(at: indexPath) as? ColorCollectionViewCell
            cell?.configureColorCollectionViewBorderColor(with: UIColor.clear.cgColor)
        }
    }
}

extension CreationEventViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if !textField.text!.isEmpty {
            clearButton?.isHidden = false
            if textField.text!.count >= 38 && !isLimitSimbol {
                textField.text?.removeLast()
                isLimitSimbol = true
                setLimitSimbolLabel(containerHeightLimitSimbol: 819, containerHeightNotLimitSimbol: 781)
            } else if textField.text!.count < 38 && isLimitSimbol {
                isLimitSimbol = false
                setLimitSimbolLabel(containerHeightLimitSimbol: 819, containerHeightNotLimitSimbol: 781)
            }
        } else {
            clearButton?.isHidden = true
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        creationEvent.name = textField.text ?? ""
        clearButton?.isHidden = true
        checkAllFillField(isHabit: creationEvent.sheduleString() == "")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

