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
            case .Monday: return "Понедельник"
            case .Tuesday: return "Вторник"
            case .Wednesday: return "Среда"
            case .Thursday: return "Четверг"
            case .Friday: return "Пятница"
            case .Saturday: return "Суббота"
            case .Sunday: return "Воскресенье"
        }
    }
    
    var shortName: String {
        switch self {
            case .Monday: return "Пн"
            case .Tuesday: return "Вт"
            case .Wednesday: return "Ср"
            case .Thursday: return "Чт"
            case .Friday: return "Пт"
            case .Saturday: return "Сб"
            case .Sunday: return "Вс"
        }
    }
}
