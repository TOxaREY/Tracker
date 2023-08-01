//
//  WeekDay.swift
//  Tracker
//
//  Created by Anton Reynikov on 18.05.2023.
//

import Foundation

enum WeekDay: Int, CaseIterable {
    case Monday,
         Tuesday,
         Wednesday,
         Thursday,
         Friday,
         Saturday,
         Sunday
    
    var name: String {
        switch self {
        case .Monday: return NSLocalizedString(
            "monday.full",
            comment: "Full monday"
        )
        case .Tuesday: return NSLocalizedString(
            "tuesday.full",
            comment: "Full tuesday"
        )
        case .Wednesday: return NSLocalizedString(
            "wednesday.full",
            comment: "Full wednesday"
        )
        case .Thursday: return NSLocalizedString(
            "thursday.full",
            comment: "Full thursday"
        )
        case .Friday: return NSLocalizedString(
            "friday.full",
            comment: "Full friday"
        )
        case .Saturday: return NSLocalizedString(
            "saturday.full",
            comment: "Full saturday"
        )
        case .Sunday: return NSLocalizedString(
            "sunday.full",
            comment: "Full sunday"
        )
        }
    }
    
    var shortName: String {
        switch self {
        case .Monday: return NSLocalizedString(
            "monday.short",
            comment: "Short monday"
        )
        case .Tuesday: return NSLocalizedString(
            "tuesday.short",
            comment: "Short tuesday"
        )
        case .Wednesday: return NSLocalizedString(
            "wednesday.short",
            comment: "Short wednesday"
        )
        case .Thursday: return NSLocalizedString(
            "thursday.short",
            comment: "Short thursday"
        )
        case .Friday: return NSLocalizedString(
            "friday.short",
            comment: "Short friday"
        )
        case .Saturday: return NSLocalizedString(
            "saturday.short",
            comment: "Short saturday"
        )
        case .Sunday: return NSLocalizedString(
            "sunday.short",
            comment: "Short sunday"
        )
        }
    }
}
