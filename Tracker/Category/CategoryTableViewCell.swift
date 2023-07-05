//
//  CategoryTableViewCell.swift
//  Tracker
//
//  Created by Anton Reynikov on 19.05.2023.
//

import UIKit

final class CategoryTableViewCell: UITableViewCell {
    convenience init(title: String, isChecked: Bool) {
        self.init()
        selectionStyle = .none
        
        let label = UILabel()
        label.font = .ypRegular_17
        label.textColor = .ypBlack
        label.text = title
        label.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(label)
        
        let imageView = UIImageView()
        if isChecked {
            imageView.image = UIImage(named: "done")
        } else {
            imageView.image = UIImage(named: "nil")
        }
        imageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageView)
        
        self.backgroundColor = .ypBackground
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            label.trailingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: -16),
            imageView.heightAnchor.constraint(equalToConstant: 24),
            imageView.widthAnchor.constraint(equalToConstant: 24),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}

