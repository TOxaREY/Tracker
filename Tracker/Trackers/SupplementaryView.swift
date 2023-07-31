//
//  SupplementaryView.swift
//  Tracker
//
//  Created by Anton Reynikov on 25.05.2023.
//

import UIKit

final class SupplementaryView: UICollectionReusableView {
    let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = .ypBold_19
        titleLabel.textColor = .ypBlack
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 28)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
