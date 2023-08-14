//
//  StatisticCollectionViewCell.swift
//  Tracker
//
//  Created by Anton Reynikov on 10.08.2023.
//

import UIKit

final class StatisticCollectionViewCell: UICollectionViewCell {
    let colors = Colors()
    private lazy var completedTrackersCountLabel: UILabel = {
        let completedTrackersCountLabel = UILabel()
        completedTrackersCountLabel.font = .ypBold_34
        completedTrackersCountLabel.textColor = colors.darkModeForegroundColor
        completedTrackersCountLabel.textAlignment = .left
        completedTrackersCountLabel.translatesAutoresizingMaskIntoConstraints = false
        return completedTrackersCountLabel
    }()
    
    private lazy var completedTrackersTitle: UILabel = {
        let completedTrackersTitle = UILabel()
        completedTrackersTitle.text = NSLocalizedString(
            "trackersCompleted.title",
            comment: "Title trackers completed"
        )
        completedTrackersTitle.font = .ypMedium_12
        completedTrackersTitle.textColor = colors.darkModeForegroundColor
        completedTrackersTitle.textAlignment = .left
        completedTrackersTitle.translatesAutoresizingMaskIntoConstraints = false
        return completedTrackersTitle
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(completedTrackersCountLabel)
        contentView.addSubview(completedTrackersTitle)
        
        contentView.backgroundColor = .clear
        contentView.layer.cornerRadius = 16
        let gradient = UIImage.gradientImage(
            bounds: contentView.bounds,
            colors: [
                UIColor(hex: "#fd4c49ff")!,
                UIColor(hex: "#46e69dff")!,
                UIColor(hex: "#007bfaff")!
            ]
        )
        let gradientColor = UIColor(patternImage: gradient)
        contentView.layer.borderColor = gradientColor.cgColor
        contentView.layer.borderWidth = 1
        contentView.layer.masksToBounds = true
        
        NSLayoutConstraint.activate([
            completedTrackersCountLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            completedTrackersCountLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            completedTrackersTitle.topAnchor.constraint(equalTo: completedTrackersCountLabel.bottomAnchor, constant: 7),
            completedTrackersTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12)
        ])
    }
    
    func setCompletedTrackersCountLabelText(number: String) {
        completedTrackersCountLabel.text = number
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

