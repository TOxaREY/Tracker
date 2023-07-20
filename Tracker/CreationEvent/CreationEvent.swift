//
//  CreationEvent.swift
//  Tracker
//
//  Created by Anton Reynikov on 19.05.2023.
//

import UIKit

final class CreationEvent {
    var name = ""
    var categoryArray: [(title: String, isChecked: Bool)] = []
    var category = ""
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
    
    func checkedCategory(index: Int) {
        for i in 0...categoryArray.count - 1 {
            categoryArray[i].isChecked = false
        }
        categoryArray[index].isChecked = true
    }
}
