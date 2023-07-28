//
//  CategoryViewModel.swift
//  Tracker
//
//  Created by Anton Reynikov on 27.07.2023.
//

import UIKit

final class CategoryViewModel {
    @Observable
    private(set) var categories: [(title: String, isChecked: Bool)] = []
    
    private let trackerCategoryStore: TrackerCategoryStore
    
    convenience init() {
        self.init(trackerCategoryStore: TrackerCategoryStore())
    }
    
    init(trackerCategoryStore: TrackerCategoryStore) {
        self.trackerCategoryStore = trackerCategoryStore
        trackerCategoryStore.delegate = self
        categories = trackerCategoryStore.getCategories()
    }
    
    func setTitleCategory(index: Int) -> String {
        trackerCategoryStore.setSelectedCategory(title: categories[index].title)
        return categories[index].title
    }
}

extension CategoryViewModel: TrackerCategoryStoreDelegate {
    func didCategoriesUpdate() {
        categories = trackerCategoryStore.getCategories()
    }
}
