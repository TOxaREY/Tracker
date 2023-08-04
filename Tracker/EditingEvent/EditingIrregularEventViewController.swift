//
//  EditingIrregularEventViewController.swift
//  Tracker
//
//  Created by Anton Reynikov on 03.08.2023.
//

import UIKit

final class EditingIrregularEventViewController: CreationEventViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = NSLocalizedString(
            "editingIrregularEvent.title",
            comment: "Title editing irregular event"
        )

        setNumberOfDaysLabelText(id: creationEvent.id)
        setNameTracker(name: creationEvent.name)
        setNewTitleCreateButton()
        setNameTrackerTextFieldConstraint()
    }
    
    override func setContainerAndTableViewHeight(containerHeight: CGFloat, tableViewHeight: CGFloat) {
        super.setContainerAndTableViewHeight(containerHeight: 784, tableViewHeight: 75)
    }
    
    override func setLimitSimbolLabel(containerHeightLimitSimbol: CGFloat, containerHeightNotLimitSimbol: CGFloat) {
        super.setLimitSimbolLabel(
            containerHeightLimitSimbol: 822,
            containerHeightNotLimitSimbol: 784
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
                shedule: nil,
                fixed: creationEvent.fixed)
        )
    }
    
    override func checkAllFillField(isHabit: Bool) {
        super.checkAllFillField(isHabit: false)
    }
    

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let categoryVC = CategoryViewController()
        categoryVC.delegateDataSource = self
        let navVC = UINavigationController(rootViewController: categoryVC)
        navVC.modalPresentationStyle = .automatic
        present(navVC, animated: true)
    }
    
    override func setDataSource() {
        let items: [(title: String, subtitle: String)] = [
            (
                NSLocalizedString(
                    "category.title",
                    comment: "Title category"
                ),
                creationEvent.categoryName
            )
        ]
        dataSource = TableViewStaticDataSource(cells: items.map { CreationTableViewCell(title: $0.title, subtitle: $0.subtitle) })
        tableView.dataSource = dataSource
        tableView.reloadData()
        checkAllFillField(isHabit: false)
    }
    

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setColorTracker(color: creationEvent.color ?? UIColor())
        setEmojiTracker(emoji: creationEvent.emoji)
    }
}

