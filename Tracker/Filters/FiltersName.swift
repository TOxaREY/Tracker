//
//  FiltersName.swift
//  Tracker
//
//  Created by Anton Reynikov on 01.08.2023.
//

import Foundation

enum FiltersName: Int, CaseIterable {
    case AllTrackers,
         TodayTrackers,
         СompletedTrackers,
         NotCompletedTrackers
    
    var name: String {
        switch self {
        case .AllTrackers: return NSLocalizedString(
            "allTrackers",
            comment: "All trackers"
        )
        case .TodayTrackers: return NSLocalizedString(
            "todayTrackers",
            comment: "All trackers"
        )
        case .СompletedTrackers: return NSLocalizedString(
            "сompleted",
            comment: "Completed"
        )
        case .NotCompletedTrackers: return NSLocalizedString(
            "notCompleted",
            comment: "Not completed"
        )
        }
    }
}
