//
//  CreationEvent.swift
//  Tracker
//
//  Created by Anton Reynikov on 19.05.2023.
//

import UIKit

final class CreationEvent {
    let sheduleIrregullarEvent: [Bool] = [true, true, true, true, true, true, true]
    var name = ""
    var categoryArray: [(title: String, isChecked: Bool)] = []
    var category = ""
    var shedule: [Bool] = [false, false, false, false, false, false, false]
    var color: UIColor? = nil
    var emoji = ""
    
    func sheduleString() -> String {
        var str = ""
        var strArr: [String] = []
        if shedule.contains(false) {
            for i in 0...shedule.count - 1 {
                if shedule[i] {
                    switch i {
                    case 0: strArr.append("Пн")
                    case 1: strArr.append("Вт")
                    case 2: strArr.append("Ср")
                    case 3: strArr.append("Чт")
                    case 4: strArr.append("Пт")
                    case 5: strArr.append("Сб")
                    default: strArr.append("Вс")
                    }
                }
            }
            str = strArr.joined(separator: " ,")
        } else {
            str = "Каждый день"
        }
        return str
    }
    
    func checkedCategory(index: Int) {
        for i in 0...categoryArray.count - 1 {
            categoryArray[i].isChecked = false
        }
        categoryArray[index].isChecked = true
    }
}
