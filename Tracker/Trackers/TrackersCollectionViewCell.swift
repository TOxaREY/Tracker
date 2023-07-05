//
//  TrackersCollectionViewCell.swift
//  Tracker
//
//  Created by Anton Reynikov on 25.05.2023.
//

import UIKit

final class TrackersCollectionViewCell: UICollectionViewCell {
    var cardView = UIView()
    var emojiLabel = UILabel()
    var nameLabel = UILabel()
    var daysLabel = UILabel()
    var viewEmoji = UIView()
    var plusButton = UIButton()
    var indexPathSection = Int()
    var indexPathRow = Int()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        cardView.layer.cornerRadius = 16
        cardView.clipsToBounds = true
        cardView.backgroundColor = .clear
        cardView.translatesAutoresizingMaskIntoConstraints = false
        
        viewEmoji.layer.cornerRadius = 12
        viewEmoji.clipsToBounds = true
        viewEmoji.backgroundColor = UIColor(hex: "#ffffff4d")
        viewEmoji.translatesAutoresizingMaskIntoConstraints = false
        emojiLabel.font = .ypMedium_16
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        viewEmoji.addSubview(emojiLabel)
        cardView.addSubview(viewEmoji)
        
        nameLabel.font = .ypMedium_12
        nameLabel.textColor = .ypWhite
        nameLabel.textAlignment = .left
        nameLabel.numberOfLines = 0
        nameLabel.lineBreakMode = .byWordWrapping
        nameLabel.sizeToFit()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(nameLabel)
        
        daysLabel.font = .ypMedium_12
        daysLabel.textColor = .ypBlack
        daysLabel.textAlignment = .left
        daysLabel.translatesAutoresizingMaskIntoConstraints = false
        
        plusButton.layer.cornerRadius = 17
        plusButton.clipsToBounds = true
        plusButton.translatesAutoresizingMaskIntoConstraints = false
        plusButton.addTarget(self, action: #selector(didTapPlusButton), for: .touchUpInside)
        
        contentView.addSubview(cardView)
        contentView.addSubview(daysLabel)
        contentView.addSubview(plusButton)

        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cardView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 90 / 148),
            viewEmoji.heightAnchor.constraint(equalToConstant: 24),
            viewEmoji.widthAnchor.constraint(equalToConstant: 24),
            viewEmoji.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 12),
            viewEmoji.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            emojiLabel.centerXAnchor.constraint(equalTo: viewEmoji.centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: viewEmoji.centerYAnchor),
            nameLabel.topAnchor.constraint(greaterThanOrEqualTo: viewEmoji.bottomAnchor, constant: 8),
            nameLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -12),
            nameLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: cardView.trailingAnchor, constant: -12),
            daysLabel.topAnchor.constraint(equalTo: cardView.bottomAnchor, constant: 16),
            daysLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            plusButton.heightAnchor.constraint(equalToConstant: 34),
            plusButton.widthAnchor.constraint(equalToConstant: 34),
            plusButton.centerYAnchor.constraint(equalTo: daysLabel.centerYAnchor),
            plusButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12)
        ])
    }
    
    @objc func didTapPlusButton() {
        NotificationCenter.default.post(
            name: NSNotification.Name(rawValue: "tapPlusButton"),
            object: nil,
            userInfo: ["indexPathSection": indexPathSection, "indexPathRow": indexPathRow]
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
