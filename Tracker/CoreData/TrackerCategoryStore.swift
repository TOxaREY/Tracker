//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Anton Reynikov on 21.07.2023.
//

import UIKit
import CoreData

final class TrackerCategoryStore: NSObject {
    weak var delegate: TrackerCategoryStoreDelegate?
    private let trackerStore = TrackerStore()
    private let context: NSManagedObjectContext
    private var fetchedResultsController: NSFetchedResultsController<TrackerCategoryCoreData>!
    
    convenience override init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        try! self.init(context: context)
    }
    
    init(context: NSManagedObjectContext) throws {
        self.context = context
        super.init()
        
        let fetchRequest = TrackerCategoryCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \TrackerCategoryCoreData.title, ascending: true)]
        let controller = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        controller.delegate = self
        self.fetchedResultsController = controller
        try controller.performFetch()
    }
    
    func addTracker(title: String, tracker: Tracker) {
        let request = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(
            format: "%K == %@",
            #keyPath(TrackerCategoryCoreData.title),
            title
        )
        
        do {
            if let oldCategory = try context.fetch(request).first {
                oldCategory.addToTrackers(trackerStore.addTracker(tracker: tracker, context: context))
            } else {
                let newCategory = TrackerCategoryCoreData(context: context)
                newCategory.title = title
                newCategory.addToTrackers(trackerStore.addTracker(tracker: tracker, context: context))
            }
        } catch let error {
            print(error)
        }
        
        do {
            try context.save()
        } catch let error {
            print(error)
        }
    }
    
    func updateTracker(title: String, tracker: Tracker) {
        let requestTracker = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        requestTracker.returnsObjectsAsFaults = false
        requestTracker.predicate = NSPredicate(
            format: "%K == %@",
            #keyPath(TrackerCoreData.idTracker),
            tracker.id as NSUUID
        )
        
        do {
            guard let trackerFromDB = try context.fetch(requestTracker).first else { throw TrackerCoreDataError.getTrackerCoreDataError}
            trackerStore.updateTracker(tracker: tracker, trackerCoreData: trackerFromDB)
            let oldCategoryTrackerFromDB = trackerFromDB.category?.title
            if oldCategoryTrackerFromDB != title {
                let requestCategories = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
                requestCategories.returnsObjectsAsFaults = false

                do {
                    let categories = try context.fetch(requestCategories)
                    categories.forEach { category in
                        if category.title == title {
                            category.addToTrackers(trackerFromDB)
                        } else if category.title == oldCategoryTrackerFromDB {
                            category.removeFromTrackers(trackerFromDB)
                        }
                    }
                } catch let error {
                    print(error)
                }
            }
        } catch let error {
            print(error)
        }

        do {
            try context.save()
        } catch let error {
            print(error)
        }
    }
    
    func addCategory(title: String) {
        let request = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
        request.returnsObjectsAsFaults = false
        
        do {
            let categories = try context.fetch(request)
            categories.forEach { category in
                category.isChecked = false
            }
        } catch let error {
            print(error)
        }
        
        let trackerCategotyCoreData = TrackerCategoryCoreData(context: context)
        trackerCategotyCoreData.title = title
        trackerCategotyCoreData.isChecked = true
        
        do {
            try context.save()
        } catch let error {
            print(error)
        }
    }
    
    func setSelectedCategory(title: String) {
        let request = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
        request.returnsObjectsAsFaults = false
        
        do {
            let categories = try context.fetch(request)
            categories.forEach { category in
                if category.title == title {
                    category.isChecked = true
                } else {
                    category.isChecked = false
                }
            }
        } catch let error {
            print(error)
        }
        
        do {
            try context.save()
        } catch let error {
            print(error)
        }
    }
    
    func getSelectedCategory() -> String {
        var result: String = ""
        let request = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(
            format: "%K == %@",
            #keyPath(TrackerCategoryCoreData.isChecked),
            NSNumber(value: true)
        )
        
        do {
            if let checkedCategory = try context.fetch(request).first {
                result = checkedCategory.title ?? ""
            } else {
                return result
            }
        } catch let error {
            print(error)
        }
        return result
    }
    
    func getCategories() -> [(title: String, isChecked: Bool)] {
        var result: [(title: String, isChecked: Bool)] = []
        let request = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
        request.returnsObjectsAsFaults = false
        request.sortDescriptors = [NSSortDescriptor(keyPath: \TrackerCategoryCoreData.title, ascending: true)]
        
        do {
            let categories = try context.fetch(request)
            categories.forEach { category in
                result.append((title: category.title ?? "", isChecked: category.isChecked))
            }
        } catch let error {
            print(error)
        }
        
        return result
    }
    
    func getTrackerCategory() -> [TrackerCategory] {
        var trackerCategory: [TrackerCategory] = []
        var trackers: [Tracker] = []
        var fixedTrackers: [Tracker] = []
        let request = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
        request.returnsObjectsAsFaults = false
        
        do {
            let categories = try context.fetch(request)
            do {
                try categories.forEach { category in
                    try category.trackers?.forEach { trk in
                        let tracker = try trackerStore.getTracker(set: trk)
                        if tracker.fixed {
                            fixedTrackers.append(tracker)
                        } else {
                            trackers.append(tracker)
                        }
                    }
                    trackerCategory.append(TrackerCategory(title: category.title ?? "", trackers: trackers))
                    trackers = []
                }
                trackerCategory.insert(TrackerCategory(
                    title: NSLocalizedString(
                        "pinned.title",
                        comment: "Title pinned category"
                    ),
                    trackers: fixedTrackers),
                                       at: 0
                )
            } catch let error {
                print(error)
            }
        } catch let error {
            print(error)
            return []
        }
        return trackerCategory
    }
}

extension TrackerCategoryStore: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        delegate?.didCategoriesUpdate()
    }
}
