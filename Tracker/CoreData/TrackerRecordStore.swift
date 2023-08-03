//
//  TrackerRecordStore.swift
//  Tracker
//
//  Created by Anton Reynikov on 21.07.2023.
//

import UIKit
import CoreData

final class TrackerRecordStore: NSObject {
    weak var delegate: TrackerRecordStoreDelegate?
    private let context: NSManagedObjectContext
    private var fetchedResultsController: NSFetchedResultsController<TrackerRecordCoreData>!
    
    convenience override init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        try! self.init(context: context)
    }
    
    init(context: NSManagedObjectContext) throws {
        self.context = context
        super.init()
        
        let fetchRequest = TrackerRecordCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \TrackerRecordCoreData.date, ascending: true)]
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
    
    func addRecord(id: UUID, date: Date) {
        let request = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(
            format: "%K == %@",
            #keyPath(TrackerCoreData.idTracker),
            id as NSUUID
        )
        do {
            let tracker = try context.fetch(request).first
            let record = TrackerRecordCoreData(context: context)
            record.date = date
            record.tracker = tracker
            do {
                try context.save()
            } catch let error {
                print(error)
            }
        } catch let error {
            print(error)
        }
    }
    
    func removeRecord(id: UUID, date: Date) {
        let request = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(
            format: "%K.%K == %@ AND %K == %@",
            #keyPath(TrackerRecordCoreData.tracker),
            #keyPath(TrackerCoreData.idTracker),
            id as NSUUID,
            #keyPath(TrackerRecordCoreData.date),
            date as NSDate
        )
        do {
            let record = try context.fetch(request).first ?? NSManagedObject()
            context.delete(record)
        } catch let error {
            print(error)
        }
        
        do {
            try context.save()
        } catch let error {
            print(error)
        }
    }
    
    func removeRecords(tracker: Tracker) {
        let request = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(
            format: "%K.%K == %@",
            #keyPath(TrackerRecordCoreData.tracker),
            #keyPath(TrackerCoreData.idTracker),
            tracker.id as NSUUID
        )
        do {
            let records = try context.fetch(request)
            records.forEach { record in
                context.delete(record)
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
    
    func getCompletedTrackers() -> [TrackerRecord] {
        var trackerRecords: [TrackerRecord] = []
        let request = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        request.returnsObjectsAsFaults = false
        do {
            let completedTrackers = try context.fetch(request)
            completedTrackers.forEach { record in
                trackerRecords.append(TrackerRecord(id: record.tracker?.idTracker ?? UUID(), date: record.date ?? Date()))
            }
        } catch let error {
            print(error)
            return []
        }
        return trackerRecords
    }
}

extension TrackerRecordStore: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        delegate?.didRecordsUpdate()
    }
}
