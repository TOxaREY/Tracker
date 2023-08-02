//
//  TrackersViewController.swift
//  Tracker
//
//  Created by Anton Reynikov on 03.05.2023.
//

import UIKit

final class TrackersViewController: UIViewController,
                                    TrackersViewControllerDelegate,
                                    FiltersDelegate {
    var categories: [TrackerCategory] = []
    var visibleCategories: [TrackerCategory] = []
    var completedTrackers: [TrackerRecord] = []
    var currentDate: Date = Date()
    var completedId: Set<UUID> = []
    @Observable
    var filtersName: FiltersName = FiltersName.AllTrackers
    private var navBar: UINavigationBar?
    private let trackerCategoryStore = TrackerCategoryStore()
    private let trackerRecordStore = TrackerRecordStore()
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = NSLocalizedString(
            "trackers.title",
            comment: "Title trackers"
        )
        titleLabel.textColor = .ypBlack
        titleLabel.textAlignment = .left
        titleLabel.font = .ypBold_34
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }()
    
    private lazy var dateLabel: UILabel = {
        let dateLabel = UILabel()
        dateLabel.backgroundColor = .ypBackgroundTrackersField
        dateLabel.textColor = .ypBlack
        dateLabel.textAlignment = .center
        dateLabel.font = .ypRegular_17
        dateLabel.layer.cornerRadius = 8
        dateLabel.clipsToBounds = true
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        return dateLabel
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .date
        datePicker.locale = .current
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
        return datePicker
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 14
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var searchTextField: UISearchTextField = {
        let searchTextField = UISearchTextField()
        searchTextField.attributedPlaceholder = NSAttributedString(
            string: NSLocalizedString(
                "search.placeholder",
                comment: "Placeholder search"
            ),
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
        return searchTextField
    }()
    
    private lazy var cancelButton: UIButton = {
        let cancelButton = UIButton()
        cancelButton.backgroundColor = .clear
        cancelButton.titleLabel?.font = .ypRegular_17
        cancelButton.setTitleColor(.ypBlue, for: .normal)
        cancelButton.setTitle(
            NSLocalizedString(
                "cancel",
                comment: "Cancel"
            ),
            for: .normal
        )
        cancelButton.layer.cornerRadius = 16
        cancelButton.layer.masksToBounds = true
        cancelButton.addTarget(
            self,
            action: #selector(didCancelButton),
            for: .touchUpInside
        )
        cancelButton.isHidden = true
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        return cancelButton
    }()
    
    private lazy var messageImageView: UIImageView = {
        let messageImageView = UIImageView()
        messageImageView.contentMode = .scaleAspectFit
        messageImageView.isHidden = true
        messageImageView.translatesAutoresizingMaskIntoConstraints = false
        return messageImageView
    }()
    
    private lazy var messageLabel: UILabel = {
        let messageLabel = UILabel()
        messageLabel.text = NSLocalizedString(
            "whatWillWeTrack.message",
            comment: "Text message label"
        )
        messageLabel.textColor = .ypBlack
        messageLabel.textAlignment = .center
        messageLabel.font = .ypMedium_12
        messageLabel.isHidden = true
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        return messageLabel
    }()
    
    private lazy var trackersCollectionView: UICollectionView = {
        let trackersCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        trackersCollectionView.dataSource = self
        trackersCollectionView.delegate = self
        trackersCollectionView.register(SupplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        trackersCollectionView.register(TrackersCollectionViewCell.self, forCellWithReuseIdentifier: "trackersCell")
        trackersCollectionView.backgroundColor = .clear
        trackersCollectionView.allowsMultipleSelection = false
        trackersCollectionView.translatesAutoresizingMaskIntoConstraints = false
        return trackersCollectionView
    }()
    
    private lazy var filtersButton: UIButton = {
        let filtersButton = UIButton()
        filtersButton.backgroundColor = .ypBlue
        filtersButton.titleLabel?.font = .ypRegular_17
        filtersButton.setTitleColor(.ypWhite, for: .normal)
        filtersButton.setTitle(
            NSLocalizedString(
                "filters.title",
                comment: "Title button filters"
            ),
            for: .normal
        )
        filtersButton.layer.cornerRadius = 16
        filtersButton.layer.masksToBounds = true
        filtersButton.addTarget(
            self,
            action: #selector(didFiltersButton),
            for: .touchUpInside
        )
        filtersButton.isHidden = false
        filtersButton.translatesAutoresizingMaskIntoConstraints = false
        return filtersButton
    }()
    
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
        
        self.view.backgroundColor = .ypWhite
        setCategoriesAndRecords()
        makeNavBar()
        addSubviews()
        makeConstraints()
        updateDateLabel(date: Date())
        setVisibleCategoriesForDate()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.didTapPlusButton),
            name: NSNotification.Name(rawValue: "tapPlusButton"),
            object: nil)
        $filtersName.bind { [weak self] _ in
            guard let self = self else { return }
            self.setFilteredTracker()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (touches.first) != nil {
            view.endEditing(true)
        }
        super.touchesBegan(touches, with: event)
    }
    
    func checkDateAndReloadTrackersCollectionView() {
        setVisibleCategoriesForDate()
        trackersCollectionView.reloadData()
    }
    
    private func setCategoriesAndRecords() {
        trackerCategoryStore.delegate = self
        trackerRecordStore.delegate = self
        categories = trackerCategoryStore.getTrackerCategory()
        completedTrackers = trackerRecordStore.getCompletedTrackers()
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
    
    private func addSubviews() {
        view.addSubview(titleLabel)
        view.addSubview(datePicker)
        view.addSubview(dateLabel)
        stackView.addArrangedSubview(searchTextField)
        stackView.addArrangedSubview(cancelButton)
        view.addSubview(stackView)
        view.addSubview(messageImageView)
        view.addSubview(messageLabel)
        view.addSubview(trackersCollectionView)
        view.addSubview(filtersButton)
    }
    
    private func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            datePicker.heightAnchor.constraint(equalToConstant: 34),
            datePicker.widthAnchor.constraint(equalToConstant: 77),
            datePicker.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            datePicker.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            dateLabel.heightAnchor.constraint(equalToConstant: 34),
            dateLabel.widthAnchor.constraint(equalToConstant: 77),
            dateLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            stackView.heightAnchor.constraint(equalToConstant: 36),
            stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 7),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            messageImageView.widthAnchor.constraint(equalToConstant: 80),
            messageImageView.heightAnchor.constraint(equalToConstant: 80),
            messageImageView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 230),
            messageImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            messageLabel.topAnchor.constraint(equalTo: messageImageView.bottomAnchor, constant: 8),
            messageLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            trackersCollectionView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 10),
            trackersCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            trackersCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            trackersCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            filtersButton.heightAnchor.constraint(equalToConstant: 50),
            filtersButton.widthAnchor.constraint(equalToConstant: 114),
            filtersButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            filtersButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
    
    private func formattedDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yy"
        
        return dateFormatter.string(from: date)
    }
    
    private func updateDateLabel(date: Date) {
        let dateString = formattedDate(date: date)
        dateLabel.text = dateString
    }
    
    private func messageNotHidden() {
        messageImageView.isHidden = false
        messageLabel.isHidden = false
    }
    
    private func messageHidden() {
        messageImageView.isHidden = true
        messageLabel.isHidden = true
    }
    
    private func checkSheduleDay(sheduleArr: [WeekDay]?) -> Bool {
        guard let sheduleArray = sheduleArr else { return true }
        let currentDayNumber = Calendar.current.component(.weekday, from: currentDate)
        if currentDayNumber == 1 {
            if sheduleArray.contains(WeekDay(rawValue: 6)!) {
                return true
            } else {
                return false
            }
        }
        if sheduleArray.contains(WeekDay(rawValue: currentDayNumber - 2)!) {
            return true
        } else {
            return false
        }
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
    
    private func setVisibleCategoriesCompletedForDate() {
        setVisibleCategoriesForDate()
        let completedTrackerToday = completedTrackers.filter({ formattedDate(date: $0.date) == formattedDate(date: currentDate) })
        var visibleCategories: [TrackerCategory] = []
        for cat in self.visibleCategories {
            var trackersArr: [Tracker] = []
            for tr in cat.trackers {
                if completedTrackerToday.filter({ $0.id == tr.id }).count > 0 {
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
    
    private func setVisibleCategoriesNotCompletedForDate() {
        setVisibleCategoriesForDate()
        let completedTrackerToday = completedTrackers.filter({ formattedDate(date: $0.date) == formattedDate(date: currentDate) })
        var visibleCategories: [TrackerCategory] = []
        for cat in self.visibleCategories {
            var trackersArr: [Tracker] = []
            for tr in cat.trackers {
                if completedTrackerToday.filter({ $0.id == tr.id }).count == 0 {
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
    
    private func setVisibleCategoriesForName(char: String) {
        let categories = categories
        var visibleCategories: [TrackerCategory] = []
        for cat in categories {
            var trackersArr: [Tracker] = []
            for tr in cat.trackers {
                if tr.name.lowercased().hasPrefix(char.lowercased()) {
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
            messageImageView.image = UIImage(named: "not_found")
            messageLabel.text = NSLocalizedString(
                "nothingFound.message",
                comment: "Text message label"
            )
        }
    }
    
    private func setMessageWhatTracker() {
        if visibleCategories.isEmpty {
            messageImageView.image = UIImage(named: "stars")
            messageLabel.text = NSLocalizedString(
                "whatWillWeTrack.message",
                comment: "Text message label"
            )
        }
    }
    
    private func setFilteredTracker() {
        switch filtersName {
        case FiltersName.TodayTrackers:
            datePicker.date = Date()
            changeDataPicker()
        case FiltersName.СompletedTrackers:
            setVisibleCategoriesCompletedForDate()
            trackersCollectionView.reloadData()
        case FiltersName.NotCompletedTrackers:
            setVisibleCategoriesNotCompletedForDate()
            trackersCollectionView.reloadData()
        default :
            changeDataPicker()
        }
    }
    
    private func changeDataPicker() {
        updateDateLabel(date: datePicker.date)
        currentDate = datePicker.date
        checkDateAndReloadTrackersCollectionView()
    }
    
    @objc private func didChangedDatePicker() {
        filtersName = FiltersName.AllTrackers
    }
    
    @objc private func didChangedSearchTextField() {
        setVisibleCategoriesForName(char: searchTextField.text ?? "")
        trackersCollectionView.reloadData()
    }
    
    @objc private func didCancelButton() {
        cancelButton.isHidden = true
        searchTextField.text = ""
        searchTextField.resignFirstResponder()
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
                    if let completedTracker = completedTrackers[safe: index!] {
                        trackerRecordStore.removeRecord(id: completedTracker.id, date: completedTracker.date)
                    }
                } else {
                    trackerRecordStore.addRecord(id: id, date: currentDate)
                }
            } else {
                completedId.insert(id)
                trackerRecordStore.addRecord(id: id, date: currentDate)
            }
            completedTrackers = trackerRecordStore.getCompletedTrackers()
            trackersCollectionView.performBatchUpdates({
                trackersCollectionView.reloadItems(at: [IndexPath(row: indexPathRow, section: indexPathSection)])
            })
            setFilteredTracker()
        }
    }
    
    @objc private func didFiltersButton() {
        let filtersVC = FiltersViewController()
        filtersVC.delegateFilters = self
        let navVC = UINavigationController(rootViewController: filtersVC)
        navVC.modalPresentationStyle = .automatic
        present(navVC, animated: true)
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
        let visibleTrack = visibleCategories[indexPath.section].trackers[indexPath.row]
        let color = visibleTrack.color
        cell?.configureTrackersCollectionViewCell(with: TrackersCollectionViewCellModel(
            indexSection: indexPath.section,
            indexRow: indexPath.row,
            cardViewBackgroundColor: color,
            emojiText: visibleTrack.emoji,
            nameText: visibleTrack.name
        ))
        let id = visibleTrack.id
        completedTrackers.forEach { tracker in
            completedId.insert(tracker.id)
        }
        if completedId.contains(id) {
            let completeTrack = completedTrackers.filter({ $0.id == id })
            cell?.configureTrackersCollectionViewCellDaysLabel(
                with: String.localizedStringWithFormat(
                    NSLocalizedString(
                        "numberOfDays",
                        comment: "Number of completed days"
                    ),
                    completeTrack.count
                )
            )
            if completeTrack.filter({ formattedDate(date: $0.date) == formattedDate(date: currentDate) }).count > 0 {
                cell?.configureTrackersCollectionViewCellPlusButtonImage(isCompletedImage: true, color: color)
            } else {
                cell?.configureTrackersCollectionViewCellPlusButtonImage(isCompletedImage: false, color: color)
            }
        } else {
            cell?.configureTrackersCollectionViewCellDaysLabel(
                with: String.localizedStringWithFormat(
                    NSLocalizedString(
                        "numberOfDays",
                        comment: "Number of completed days"
                    ),
                    0
                )
            )
            cell?.configureTrackersCollectionViewCellPlusButtonImage(isCompletedImage: false, color: color)
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
        cancelButton.isHidden = false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension TrackersViewController: TrackerCategoryStoreDelegate {
    func didCategoriesUpdate() {
        categories = trackerCategoryStore.getTrackerCategory()
    }
}

extension TrackersViewController: TrackerRecordStoreDelegate {
    func didRecordsUpdate() {
        completedTrackers = trackerRecordStore.getCompletedTrackers()
        checkDateAndReloadTrackersCollectionView()
    }
}
