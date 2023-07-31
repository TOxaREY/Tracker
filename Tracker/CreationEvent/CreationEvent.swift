//
//  CreationEvent.swift
//  Tracker
//
//  Created by Anton Reynikov on 19.05.2023.
//

import UIKit

final class CreationEvent {
    var name = ""
    var categoryName = ""
    var shedule: [WeekDay] = []
    var color: UIColor? = nil
    var emoji = ""
    
    func sheduleString() -> String {
        var namesDaysWeek = ""
        var namesDaysWeekArray: [String] = []
        if shedule.count == 7 {
            namesDaysWeek = "Каждый день"
        } else {
            shedule.sort{ $0.rawValue < $1.rawValue }
            shedule.forEach { day in
                namesDaysWeekArray.append(day.shortName)
            }
            namesDaysWeek = namesDaysWeekArray.joined(separator: ", ")
        }
        
        return namesDaysWeek
    }
}
