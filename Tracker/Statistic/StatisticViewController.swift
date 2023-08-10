//
//  StatisticViewController.swift
//  Tracker
//
//  Created by Anton Reynikov on 15.05.2023.
//

import UIKit

final class StatisticViewController: UIViewController {
    private var navBar: UINavigationBar?
    private let colors = Colors()
    private let trackerCategoryStore = TrackerCategoryStore()
    private let trackerRecordStore = TrackerRecordStore()
    private let trackerStore = TrackerStore()
    private let params = GeometricParams(
        cellCount: 1,
        leftInset: 16,
        rightInset: 16,
        topInset: 0,
        bottomInset: 0,
        cellSpacing: 0
    )
    private var recordsCount = Int()
    private var trackersCount = Int()
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = NSLocalizedString(
            "statistics.title",
            comment: "Title statistics"
        )
        titleLabel.textColor = colors.darkModeForegroundColor
        titleLabel.textAlignment = .left
        titleLabel.font = .ypBold_34
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }()
    
    private lazy var messageImageView: UIImageView = {
        let messageImageView = UIImageView()
        messageImageView.image = UIImage(named: "error")
        messageImageView.contentMode = .scaleAspectFit
        messageImageView.isHidden = true
        messageImageView.translatesAutoresizingMaskIntoConstraints = false
        return messageImageView
    }()
    
    private lazy var messageLabel: UILabel = {
        let messageLabel = UILabel()
        messageLabel.text = NSLocalizedString(
            "nothingToAnalyze.message",
            comment: "Text message label"
        )
        messageLabel.textColor = colors.darkModeForegroundColor
        messageLabel.textAlignment = .center
        messageLabel.font = .ypMedium_12
        messageLabel.isHidden = true
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        return messageLabel
    }()
    
    private lazy var statisticCollectionView: UICollectionView = {
        let statisticCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        statisticCollectionView.dataSource = self
        statisticCollectionView.delegate = self
        statisticCollectionView.register(StatisticCollectionViewCell.self, forCellWithReuseIdentifier: "statisticCell")
        statisticCollectionView.backgroundColor = .clear
        statisticCollectionView.allowsMultipleSelection = false
        statisticCollectionView.translatesAutoresizingMaskIntoConstraints = false
        return statisticCollectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.view.backgroundColor = colors.darkModeBackgroundColor
        addSubviews()
        makeConstraints()
        trackerRecordStore.delegate = self
        trackerCategoryStore.delegate = self
        setRecordsCountAndReloadTrackersCollectionView()
    }
    
    private func addSubviews() {
        view.addSubview(titleLabel)
        view.addSubview(messageImageView)
        view.addSubview(messageLabel)
        view.addSubview(statisticCollectionView)
    }
    
    private func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            messageImageView.widthAnchor.constraint(equalToConstant: 80),
            messageImageView.heightAnchor.constraint(equalToConstant: 80),
            messageImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 246),
            messageImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            messageLabel.topAnchor.constraint(equalTo: messageImageView.bottomAnchor, constant: 8),
            messageLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            statisticCollectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 77),
            statisticCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            statisticCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            statisticCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func messageNotHidden() {
        messageImageView.isHidden = false
        messageLabel.isHidden = false
    }
    
    private func messageHidden() {
        messageImageView.isHidden = true
        messageLabel.isHidden = true
    }
    
    private func setTrackersCount() {
        trackersCount = trackerStore.getTrackersCount()
        if trackersCount == 0 {
            messageNotHidden()
        } else {
            messageHidden()
        }
    }
    
    private func setRecordsCountAndReloadTrackersCollectionView() {
        setTrackersCount()
        recordsCount = trackerRecordStore.getCompletedTrackers().count
        statisticCollectionView.reloadData()
    }
}

extension StatisticViewController: UICollectionViewDelegateFlowLayout {
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
    
    private func setCellSize(_ collectionView: UICollectionView) -> CGSize {
        let availableWidth = collectionView.frame.width - params.paddingWight
        let cellWidth = availableWidth / CGFloat(params.cellCount)
        return CGSize(width: cellWidth, height: 90)
    }
}

extension StatisticViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        setTrackersCount()
        if trackersCount == 0 {
            return 0
        } else {
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "statisticCell", for: indexPath) as? StatisticCollectionViewCell
        cell?.setCompletedTrackersCountLabelText(number: String(recordsCount))
        return cell!
    }
}

extension StatisticViewController: TrackerRecordStoreDelegate {
    func didRecordsUpdate() {
        setRecordsCountAndReloadTrackersCollectionView()
    }
}

extension StatisticViewController: TrackerCategoryStoreDelegate {
    func didCategoriesUpdate() {
        setRecordsCountAndReloadTrackersCollectionView()
    }
}


