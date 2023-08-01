//
//  CreationHabitViewController.swift
//  Tracker
//
//  Created by Anton Reynikov on 18.05.2023.
//

import UIKit

final class CreationHabitViewController: CreationEventViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = NSLocalizedString(
            "newHabit.title",
            comment: "New habit title"
        )
    }
}

