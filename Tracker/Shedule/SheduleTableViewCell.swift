//
//  SheduleTableViewCell.swift
//  Tracker
//
//  Created by Anton Reynikov on 18.05.2023.
//

import UIKit

final class SheduleTableViewCell: UITableViewCell {
    private let switchDay = UISwitch()
    private var index = Int()
    private var creationHabit: CreationEvent?
    
    convenience init(title: String, index: Int, creationHabit: CreationEvent) {
        self.init()
        self.index = index
        self.creationHabit = creationHabit
        selectionStyle = .none

        let label: UILabel = {
            let label = UILabel()
            label.font = .ypRegular_17
            label.textColor = .ypBlack
            label.text = title
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()

        contentView.addSubview(label)
        
        switchDay.onTintColor = .ypBlue
        switchDay.translatesAutoresizingMaskIntoConstraints = false
        switchDay.addTarget(self, action: #selector(onSwitchValueChanged), for: .valueChanged)
        if creationHabit.shedule.contains(WeekDay(rawValue: index)!) {
            switchDay.setOn(true, animated: false)
        } else {
            switchDay.setOn(false, animated: false)
        }
        contentView.addSubview(switchDay)

        self.backgroundColor = .ypBackground
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            switchDay.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            switchDay.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    @objc private func onSwitchValueChanged() {
        if switchDay.isOn {
            creationHabit!.shedule.append(WeekDay(rawValue: index)!)
        } else {
            creationHabit!.shedule = creationHabit!.shedule.filter { $0.rawValue != index }
        }
    }
}
