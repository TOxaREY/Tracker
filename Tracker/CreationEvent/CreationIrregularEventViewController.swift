//
//  CreationIrregularEventViewController.swift
//  Tracker
//
//  Created by Anton Reynikov on 18.05.2023.
//

import UIKit

final class CreationIrregularEventViewController: CreationEventViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = NSLocalizedString(
            "newIrregularEvent.title",
            comment: "New irregular event title"
        )
    }
    
    override func setContainerAndTableViewHeight(containerHeight: CGFloat, tableViewHeight: CGFloat) {
        super.setContainerAndTableViewHeight(containerHeight: 706, tableViewHeight: 75)
    }
    
    override func checkAllFillField(isHabit: Bool) {
        super.checkAllFillField(isHabit: false)
    }
    
    override func addTracker(shedule: [WeekDay]?) {
        super.addTracker(shedule: nil)
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
    
    override func setLimitSimbolLabel(containerHeightLimitSimbol: CGFloat, containerHeightNotLimitSimbol: CGFloat) {
        super.setLimitSimbolLabel(
            containerHeightLimitSimbol: 744,
            containerHeightNotLimitSimbol: 706
        )
    }
}

