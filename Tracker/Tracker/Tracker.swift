//
//  Tracker.swift
//  Tracker
//
//  Created by Anton Reynikov on 23.05.2023.
//

import UIKit

struct Tracker {
    let id: UUID
    let name: String
    let color: UIColor
    let emoji: String
    let shedule: [WeekDay]?
    let fixed: Bool
}
