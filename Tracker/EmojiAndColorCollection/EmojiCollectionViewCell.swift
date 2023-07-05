//
//  EmojiCollectionViewCell.swift
//  Tracker
//
//  Created by Anton Reynikov on 22.05.2023.
//

import UIKit

let emojiesArray = [
    "🙂", "😻", "🌺", "🐶", "❤️", "😱",
    "😇", "😡", "🥶", "🤔", "🙌", "🍔",
    "🥦", "🏓", "🥇", "🎸", "🏝", "😪"
]

final class EmojiCollectionViewCell: UICollectionViewCell {
    var view = UIView()
    var label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        
        label.font = .ypBold_32
        label.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(label)
        contentView.addSubview(view)
        
        
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: contentView.topAnchor),
            view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
