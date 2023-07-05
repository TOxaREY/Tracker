//
//  SheduleTableViewCell.swift
//  Tracker
//
//  Created by Anton Reynikov on 18.05.2023.
//

import UIKit

final class SheduleTableViewCell: UITableViewCell {
    let sw = UISwitch()
    var index = Int()
    var creationHabit: CreationEvent?
    
    convenience init(title: String, index: Int, creationHabit: CreationEvent) {
        self.init()
        self.index = index
        self.creationHabit = creationHabit
        selectionStyle = .none

        let label = UILabel()
        label.font = .ypRegular_17
        label.textColor = .ypBlack
        label.text = title
        label.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(label)
        
        sw.onTintColor = .ypBlue
        sw.translatesAutoresizingMaskIntoConstraints = false
        sw.addTarget(self, action: #selector(onSwitchValueChanged), for: .valueChanged)
        if creationHabit.shedule[index] {
            sw.setOn(true, animated: false)
        } else {
            sw.setOn(false, animated: false)
        }
        contentView.addSubview(sw)

        self.backgroundColor = .ypBackground
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            sw.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            sw.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    @objc func onSwitchValueChanged() {
        if sw.isOn {
            creationHabit!.shedule[index] = true
        } else {
            creationHabit!.shedule[index] = false
        }
    }
}
