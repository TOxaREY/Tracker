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
    
    func addCategoty(title: String) {
        let trackerCategotyCoreData = TrackerCategoryCoreData(context: context)
        trackerCategotyCoreData.title = title
        do {
            try context.save()
        } catch let error {
            print(error)
        }
    }
    
    func getTrackerCategoty() -> [TrackerCategory] {
        var trackerCategory: [TrackerCategory] = []
        var trackers: [Tracker] = []
        let request = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
        request.returnsObjectsAsFaults = false
        do {
            let categories = try context.fetch(request)
            do {
                try categories.forEach { category in
                    trackers = try category.trackers?.map({ try trackerStore.getTracker(tracker: $0 as! TrackerCoreData) }) ?? []
                    trackerCategory.append(TrackerCategory(title: category.title ?? "", trackers: trackers))
                }
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
