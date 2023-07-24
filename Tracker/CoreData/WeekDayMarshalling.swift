//
//  WeekDayMarshalling.swift
//  Tracker
//
//  Created by Anton Reynikov on 20.07.2023.
//

import Foundation

final class WeekDayMarshalling {
    func weekDaysToString(from weekDays: [WeekDay]?) -> String {
        guard let weekDaysArray = weekDays else { return "" }
        let stringWeekDays = weekDaysArray.map { String($0.rawValue) }.joined(separator: ",")
        return stringWeekDays
    }
    
    func stringToWeekDays(from string: String) -> [WeekDay]? {
        var weekDayArray: [WeekDay]?
        if string == "" {
            weekDayArray = nil
        } else {
            weekDayArray = string.components(separatedBy: ",").map { WeekDay(rawValue: Int($0)!)! }
        }
        return weekDayArray
    }
}
