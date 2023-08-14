//
//  EditingHabitViewController.swift
//  Tracker
//
//  Created by Anton Reynikov on 03.08.2023.
//

import UIKit

final class EditingHabitViewController: CreationEventViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = NSLocalizedString(
            "editingHabit.title",
            comment: "Editing habit title"
        )
        
        setNumberOfDaysLabelText(id: creationEvent.id)
        setNameTracker(name: creationEvent.name)
        setNewTitleCreateButton()
        setNameTrackerTextFieldConstraint()
    }
    
    override func setContainerAndTableViewHeight(containerHeight: CGFloat, tableViewHeight: CGFloat) {
        super.setContainerAndTableViewHeight(containerHeight: 859, tableViewHeight: 150)
    }
    
    override func setLimitSimbolLabel(containerHeightLimitSimbol: CGFloat, containerHeightNotLimitSimbol: CGFloat) {
        super.setLimitSimbolLabel(
            containerHeightLimitSimbol: 897,
            containerHeightNotLimitSimbol: 859
        )
    }
    
    override func addTracker(shedule: [WeekDay]?) {
        trackerCategoryStore.updateTracker(
            title: creationEvent.categoryName,
            tracker: Tracker(
                id: creationEvent.id,
                name: creationEvent.name,
                color: creationEvent.color ?? UIColor(),
                emoji: creationEvent.emoji,
                shedule: creationEvent.shedule,
                fixed: creationEvent.fixed)
        )
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setColorTracker(color: creationEvent.color ?? UIColor())
        setEmojiTracker(emoji: creationEvent.emoji)
    }
}
