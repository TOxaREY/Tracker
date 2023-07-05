//
//  CreationTableViewCell.swift
//  Tracker
//
//  Created by Anton Reynikov on 18.05.2023.
//

import UIKit

final class CreationTableViewCell: UITableViewCell {
    convenience init(title: String, subtitle: String) {
        self.init()
        selectionStyle = .none
        let subLabel = UILabel()
        
        let label = UILabel()
        label.font = .ypRegular_17
        label.textColor = .ypBlack
        label.text = title
        label.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(label)
        
        if subtitle != "" {
            subLabel.font = .ypRegular_17
            subLabel.textColor = .ypGray
            subLabel.text = subtitle
            subLabel.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(subLabel)
        }
        
        let image = UIImageView()
        image.image = UIImage(named: "arrow_forward")
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(image)
        
        self.backgroundColor = .ypBackground
        
        if subtitle != "" {
            NSLayoutConstraint.activate([
                label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
                subLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                subLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -14),
                image.heightAnchor.constraint(equalToConstant: 24),
                image.widthAnchor.constraint(equalToConstant: 24),
                image.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
                image.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
            ])
        } else {
            NSLayoutConstraint.activate([
                label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                image.heightAnchor.constraint(equalToConstant: 24),
                image.widthAnchor.constraint(equalToConstant: 24),
                image.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
                image.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
            ])
        }
    }
}
