//
//  CategoryViewModel.swift
//  Tracker
//
//  Created by Anton Reynikov on 27.07.2023.
//

import UIKit

final class CategoryViewModel {
    weak var delegateDataSource: DataSourceDelegate?
    @Observable
    private(set) var categories: [(title: String, isChecked: Bool)] = []
    
    private let trackerCategoryStore: TrackerCategoryStore
    private var dataSource: TableViewStaticDataSource!
    
    convenience init(delegateDataSource: DataSourceDelegate?) {
        self.init(trackerCategoryStore: TrackerCategoryStore(), delegateDataSource: delegateDataSource)
    }
    
    init(trackerCategoryStore: TrackerCategoryStore, delegateDataSource: DataSourceDelegate?) {
        self.delegateDataSource = delegateDataSource
        self.trackerCategoryStore = trackerCategoryStore
        trackerCategoryStore.delegate = self
        categories = trackerCategoryStore.getCategories()
    }
    
    func categoriesIsNotEmpty() -> Bool {
        return !categories.isEmpty
    }
    
    func categoriesCount() -> Int {
        return categories.count
    }
    
    func didSelectRowTableView(index: Int) {
        let titleCategory = categories[index].title
        trackerCategoryStore.setSelectedCategory(title: titleCategory)
        delegateDataSource?.creationEvent.categoryName = titleCategory
        delegateDataSource?.setDataSource()
    }
    
    func setDataSource() -> TableViewStaticDataSource! {
        return TableViewStaticDataSource(
            cells: categories.map {
                CategoryTableViewCell(
                    title: $0.title,
                    isChecked: $0.isChecked
                )
            }
        )
    }
}

extension CategoryViewModel: TrackerCategoryStoreDelegate {
    func didCategoriesUpdate() {
        categories = trackerCategoryStore.getCategories()
    }
}
