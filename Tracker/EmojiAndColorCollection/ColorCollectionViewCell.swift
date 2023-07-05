//
//  ColorCollectionViewCell.swift
//  Tracker
//
//  Created by Anton Reynikov on 22.05.2023.
//

import UIKit

let colorsArray = [
    UIColor(hex: "#fd4c49ff"), UIColor(hex: "#ff881eff"), UIColor(hex: "#007bfaff"),
    UIColor(hex: "#6e44feff"), UIColor(hex: "#33cf69ff"), UIColor(hex: "#e66dd4ff"),
    UIColor(hex: "#f9d4d4ff"), UIColor(hex: "#34a7feff"), UIColor(hex: "#46e69dff"),
    UIColor(hex: "#35347cff"), UIColor(hex: "#ff674dff"), UIColor(hex: "#ff99ccff"),
    UIColor(hex: "#f6c48bff"), UIColor(hex: "#7994f5ff"), UIColor(hex: "#832cf1ff"),
    UIColor(hex: "#ad56daff"), UIColor(hex: "#8d72e6ff"), UIColor(hex: "#2fd058ff")
]

final class ColorCollectionViewCell: UICollectionViewCell {
    var view = UIView()
    var colorView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        colorView.layer.cornerRadius = 8
        colorView.clipsToBounds = true
        colorView.translatesAutoresizingMaskIntoConstraints = false
        
        view.layer.cornerRadius = 16
        view.layer.borderWidth = 3
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(colorView)
        contentView.addSubview(view)

        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: contentView.topAnchor),
            view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            colorView.heightAnchor.constraint(equalToConstant: 40),
            colorView.widthAnchor.constraint(equalToConstant: 40),
            colorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            colorView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

