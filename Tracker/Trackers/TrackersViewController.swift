//
//  TrackersViewController.swift
//  Tracker
//
//  Created by Anton Reynikov on 03.05.2023.
//

import UIKit

final class TrackersViewController: UIViewController, TrackersViewControllerDelegate {
    var categories: [TrackerCategory] = []
    var visibleCategories: [TrackerCategory] = []
    var completedTrackers: [TrackerRecord] = []
    var currentDate: Date = Date()
    var completedId: Set<String> = []
    private var navBar: UINavigationBar?
    private var titleLabel: UILabel?
    private var dateLabel: UILabel?
    private var datePicker: UIDatePicker?
    private var stackView: UIStackView?
    private var searchTextField: UISearchTextField?
    private var cancelButton: UIButton?
    private var messageImageView: UIImageView?
    private var messageLabel: UILabel?
    private var trackersCollectionView: UICollectionView?
    private let params = GeometricParams(
        cellCount: 2,
        leftInset: 16,
        rightInset: 16,
        topInset: 0,
        bottomInset: 0,
        cellSpacing: 9
    )

    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeNavBar()
        configureViews()
        addSubviews()
        makeConstraints()
        updateDateLabel(date: Date())
        setVisibleCategoriesForDate()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.didTapPlusButton),
            name: NSNotification.Name(rawValue: "tapPlusButton"),
            object: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (touches.first) != nil {
            view.endEditing(true)
        }
        super.touchesBegan(touches, with: event)
    }
    
    func checkDateAndReloadTrackersCollectionView() {
        setVisibleCategoriesForDate()
        trackersCollectionView?.reloadData()
    }
    
    private func makeNavBar() {
        let navBar = self.navigationController?.navigationBar
        let addTrackerButton = UIButton(type: .custom)
        addTrackerButton.setImage(UIImage(named: "plus"), for: .normal)
        addTrackerButton.addTarget(
            self,
            action: #selector(didTapAddTrackerButton),
            for: .touchUpInside
        )
        addTrackerButton.tintColor = .ypBlack
        let leftNavBarItem = UIBarButtonItem(customView: addTrackerButton)
        self.navigationItem.leftBarButtonItem = leftNavBarItem
        self.navBar = navBar
    }
        
    private func configureViews() {
        self.view.backgroundColor = .ypWhite
        
        let titleLabel = UILabel()
        titleLabel.text = "Трекеры"
        titleLabel.textColor = .ypBlack
        titleLabel.textAlignment = .left
        titleLabel.font = .ypBold_34
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabel = titleLabel
        
        let datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .date
        datePicker.locale = Locale(identifier: "ru_RU")
        datePicker.calendar.firstWeekday = 2
        datePicker.layer.cornerRadius = 8
        datePicker.clipsToBounds = true
        datePicker.tintColor = .ypBlue
        datePicker.date = Date()
        datePicker.addTarget(
            self,
            action: #selector(didChangedDatePicker),
            for: .valueChanged
        )
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        self.datePicker = datePicker
        
        let dateLabel = UILabel()
        dateLabel.backgroundColor = .ypBackgroundTrackersField
        dateLabel.textColor = .ypBlack
        dateLabel.textAlignment = .center
        dateLabel.font = .ypRegular_17
        dateLabel.layer.cornerRadius = 8
        dateLabel.clipsToBounds = true
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        self.dateLabel = dateLabel
        
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 14
        stackView.translatesAutoresizingMaskIntoConstraints = false
        self.stackView = stackView
        
        let searchTextField = UISearchTextField()
        searchTextField.attributedPlaceholder = NSAttributedString(
            string: "Поиск",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.ypGray]
        )
        searchTextField.backgroundColor = .ypBackgroundTrackersField.withAlphaComponent(0)
        searchTextField.font = .ypRegular_17
        searchTextField.textColor = .ypBlack
        searchTextField.clearButtonMode = .never
        searchTextField.delegate = self
        searchTextField.addTarget(
            self,
            action: #selector(didChangedSearchTextField),
            for: .editingChanged)
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        self.searchTextField = searchTextField
        
        let cancelButton = UIButton()
        cancelButton.backgroundColor = .clear
        cancelButton.titleLabel?.font = .ypRegular_17
        cancelButton.setTitleColor(.ypBlue, for: .normal)
        cancelButton.setTitle("Отменить", for: .normal)
        cancelButton.layer.cornerRadius = 16
        cancelButton.layer.masksToBounds = true
        cancelButton.addTarget(
            self,
            action: #selector(didCancelButton),
            for: .touchUpInside
        )
        cancelButton.isHidden = true
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        self.cancelButton = cancelButton
        
        let messageImageView = UIImageView()
        messageImageView.contentMode = .scaleAspectFit
        messageImageView.isHidden = true
        messageImageView.translatesAutoresizingMaskIntoConstraints = false
        self.messageImageView = messageImageView
        
        let messageLabel = UILabel()
        messageLabel.text = "Что будем отслеживать?"
        messageLabel.textColor = .ypBlack
        messageLabel.textAlignment = .center
        messageLabel.font = .ypMedium_12
        messageLabel.isHidden = true
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        self.messageLabel = messageLabel
        
        let trackersCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        trackersCollectionView.dataSource = self
        trackersCollectionView.delegate = self
        trackersCollectionView.register(SupplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        trackersCollectionView.register(TrackersCollectionViewCell.self, forCellWithReuseIdentifier: "trackersCell")
        trackersCollectionView.backgroundColor = .clear
        trackersCollectionView.allowsMultipleSelection = false
        trackersCollectionView.translatesAutoresizingMaskIntoConstraints = false
        self.trackersCollectionView = trackersCollectionView
    }
    
    private func addSubviews() {
        view.addSubview(titleLabel ?? UILabel())
        view.addSubview(datePicker ?? UIDatePicker())
        view.addSubview(dateLabel ?? UILabel())
        stackView?.addArrangedSubview(searchTextField ?? UISearchTextField())
        stackView?.addArrangedSubview(cancelButton ?? UIButton())
        view.addSubview(stackView ?? UIStackView())
        view.addSubview(messageImageView ?? UIImageView())
        view.addSubview(messageLabel ?? UILabel())
        view.addSubview(trackersCollectionView ?? UICollectionView())
    }
    
    private func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel!.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            titleLabel!.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            datePicker!.heightAnchor.constraint(equalToConstant: 34),
            datePicker!.widthAnchor.constraint(equalToConstant: 77),
            datePicker!.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            datePicker!.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            dateLabel!.heightAnchor.constraint(equalToConstant: 34),
            dateLabel!.widthAnchor.constraint(equalToConstant: 77),
            dateLabel!.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            dateLabel!.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            stackView!.heightAnchor.constraint(equalToConstant: 36),
            stackView!.topAnchor.constraint(equalTo: titleLabel!.bottomAnchor, constant: 7),
            stackView!.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            stackView!.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            messageImageView!.widthAnchor.constraint(equalToConstant: 80),
            messageImageView!.heightAnchor.constraint(equalToConstant: 80),
            messageImageView!.topAnchor.constraint(equalTo: searchTextField!.bottomAnchor, constant: 230),
            messageImageView!.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            messageLabel!.topAnchor.constraint(equalTo: messageImageView!.bottomAnchor, constant: 8),
            messageLabel!.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            trackersCollectionView!.topAnchor.constraint(equalTo: searchTextField!.bottomAnchor, constant: 10),
            trackersCollectionView!.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            trackersCollectionView!.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            trackersCollectionView!.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func formattedDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yy"
        
        return dateFormatter.string(from: date)
    }
    
    private func updateDateLabel(date: Date) {
        let dateString = formattedDate(date: date)
        dateLabel?.text = dateString
    }
    
    private func messageNotHidden() {
        messageImageView?.isHidden = false
        messageLabel?.isHidden = false
    }
    
    private func messageHidden() {
        messageImageView?.isHidden = true
        messageLabel?.isHidden = true
    }
    
    private func checkSheduleDay(sheduleArr: [Bool]) -> Bool {
        let currentDayNumber = Calendar.current.component(.weekday, from: currentDate)
        if currentDayNumber == 1 {
            return sheduleArr[6]
        }
        for i in 0...5 {
            if i == currentDayNumber - 2 {
                return sheduleArr[i]
            }
        }
        return false
    }
    
    private func setVisibleCategoriesForDate() {
        let categories = categories
        var visibleCategories: [TrackerCategory] = []
        for cat in categories {
            var trackersArr: [Tracker] = []
            for tr in cat.trackers {
                if checkSheduleDay(sheduleArr: tr.shedule) {
                    trackersArr.append(tr)
                }
            }
            if !trackersArr.isEmpty {
                visibleCategories.append(TrackerCategory(title: cat.title, trackers: trackersArr))
            }
        }
        self.visibleCategories = visibleCategories
        setMessageWhatTracker()
    }
    
    private func setVisibleCategoriesForName(char: String) {
        let categories = categories
        var visibleCategories: [TrackerCategory] = []
        for cat in categories {
            var trackersArr: [Tracker] = []
            for tr in cat.trackers {
                if tr.name.hasPrefix(char) {
                    trackersArr.append(tr)
                }
            }
            if !trackersArr.isEmpty {
                visibleCategories.append(TrackerCategory(title: cat.title, trackers: trackersArr))
            }
        }
        self.visibleCategories = visibleCategories
        setMessageEmptySearchResult()
    }
    
    private func setMessageEmptySearchResult() {
        if visibleCategories.isEmpty {
            messageImageView?.image = UIImage(named: "not_found")
            messageLabel?.text = "Ничего не найдено"
        }
    }
    
    private func setMessageWhatTracker() {
        if visibleCategories.isEmpty {
            messageImageView?.image = UIImage(named: "stars")
            messageLabel?.text = "Что будем отслеживать?"
        }
    }
    
    @objc private func didChangedDatePicker() {
        updateDateLabel(date: datePicker?.date ?? Date())
        currentDate = datePicker?.date ?? Date()
        checkDateAndReloadTrackersCollectionView()
    }
    
    @objc private func didChangedSearchTextField() {
        setVisibleCategoriesForName(char: searchTextField?.text ?? "")
        trackersCollectionView?.reloadData()
    }
    
    @objc private func didCancelButton() {
        cancelButton?.isHidden = true
        searchTextField?.text = ""
        searchTextField?.resignFirstResponder()
        checkDateAndReloadTrackersCollectionView()
    }
    
    @objc private func didTapAddTrackerButton() {
        let creationTrackerVC = CreationTrackerViewController()
        creationTrackerVC.delegateTrackers = self
        let navVC = UINavigationController(rootViewController: creationTrackerVC)
        navVC.modalPresentationStyle = .automatic
        present(navVC, animated: true)
    }
    
    @objc private func didTapPlusButton(notification: Notification) {
        guard let indexPathSection = notification.userInfo?["indexPathSection"] as? Int,
              let indexPathRow = notification.userInfo?["indexPathRow"] as? Int else { return }
        let id = visibleCategories[indexPathSection].trackers[indexPathRow].id
        if Date() >= currentDate {
            if completedId.contains(id) {
                let index = completedTrackers.firstIndex { $0.id == id && formattedDate(date: $0.date) == formattedDate(date: currentDate)}
                if completedTrackers.filter({ $0.id == id }).count == 1 {
                    if index != nil {
                        completedId.remove(id)
                    }
                }
                if index != nil {
                    completedTrackers.remove(at: index!)
                } else {
                    completedTrackers.append(TrackerRecord(id: id, date: currentDate))
                }
            } else {
                completedId.insert(id)
                completedTrackers.append(TrackerRecord(id: id, date: currentDate))
            }
            trackersCollectionView?.performBatchUpdates({
                trackersCollectionView?.reloadItems(at: [IndexPath(row: indexPathRow, section: indexPathSection)])
            })
        }
    }
}

extension TrackersViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellSize = setCellSize(collectionView)
        return CGSize(width: cellSize.width, height: cellSize.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: params.topInset, left: params.leftInset, bottom: params.bottomInset, right: params.rightInset)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return params.cellSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let indexPath = IndexPath(row: 0, section: section)
        let headerView = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath)
        return headerView.systemLayoutSizeFitting(CGSize(width: collectionView.frame.width,
                                                         height: UIView.layoutFittingExpandedSize.height),
                                                  withHorizontalFittingPriority: .required,
                                                  verticalFittingPriority: .fittingSizeLevel)
    }

    private func setCellSize(_ collectionView: UICollectionView) -> CGSize {
        let availableWidth = collectionView.frame.width - params.paddingWight
        let cellWidth = availableWidth / CGFloat(params.cellCount)
        return CGSize(width: cellWidth, height: 148)
    }
}

extension TrackersViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if visibleCategories.isEmpty {
            messageNotHidden()
        } else {
            messageHidden()
        }
        
        return visibleCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return visibleCategories[section].trackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "trackersCell", for: indexPath) as? TrackersCollectionViewCell
        cell?.indexPathSection = indexPath.section
        cell?.indexPathRow = indexPath.row
        let visibleTrack = visibleCategories[indexPath.section].trackers[indexPath.row]
        let color = visibleTrack.color
        cell?.cardView.backgroundColor = color
        cell?.emojiLabel.text = visibleTrack.emoji
        cell?.nameLabel.text = visibleTrack.name
        let id = visibleTrack.id
        if completedId.contains(id) {
            let completeTrack = completedTrackers.filter({ $0.id == id })
            cell?.daysLabel.text = completeTrack.count.days()
            if completeTrack.filter({ formattedDate(date: $0.date) == formattedDate(date: currentDate) }).count > 0 {
                cell?.plusButton.setImage(UIImage(named: "complete_button")?.withTintColor(color).image(alpha: 0.3), for: .normal)
            } else {
                cell?.plusButton.setImage(UIImage(named: "plus_button")?.withTintColor(color), for: .normal)
            }
        } else {
            cell?.daysLabel.text = 0.days()
            cell?.plusButton.setImage(UIImage(named: "plus_button")?.withTintColor(color), for: .normal)
        }
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as! SupplementaryView
        view.titleLabel.text = visibleCategories[indexPath.section].title
        return view
    }
}

extension TrackersViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        cancelButton?.isHidden = false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
