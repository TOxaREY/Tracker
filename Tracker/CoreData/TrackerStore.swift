//
//  TrackerStore.swift
//  Tracker
//
//  Created by Anton Reynikov on 20.07.2023.
//

import UIKit
import CoreData

final class TrackerStore: NSObject {
    weak var delegate: TrackerStoreDelegate?
    private let context: NSManagedObjectContext
    private var fetchedResultsController: NSFetchedResultsController<TrackerCoreData>?
    private let uiColorMarshalling = UIColorMarshalling()
    private let weekDaysMarshalling = WeekDayMarshalling()
    
    convenience override init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        try! self.init(context: context)
    }
    
    init(context: NSManagedObjectContext) throws {
        self.context = context
        super.init()
        
        let fetchRequest = TrackerCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \TrackerCoreData.name, ascending: true)]
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
    
    func addTracker(tracker: Tracker, context: NSManagedObjectContext) -> TrackerCoreData {
        let trackerCoreData = TrackerCoreData(context: context)
        trackerCoreData.idTracker = tracker.id
        trackerCoreData.name = tracker.name
        trackerCoreData.color = uiColorMarshalling.hexString(from: tracker.color)
        trackerCoreData.emoji = tracker.emoji
        trackerCoreData.shedule = weekDaysMarshalling.weekDaysToString(from: tracker.shedule)
        trackerCoreData.fixed = NSNumber(value: tracker.fixed)
        return trackerCoreData
    }
    
    func updateTracker(tracker: Tracker, trackerCoreData: TrackerCoreData) -> TrackerCoreData {
        trackerCoreData.name = tracker.name
        trackerCoreData.color = uiColorMarshalling.hexString(from: tracker.color)
        trackerCoreData.emoji = tracker.emoji
        trackerCoreData.shedule = weekDaysMarshalling.weekDaysToString(from: tracker.shedule)
        trackerCoreData.fixed = NSNumber(value: tracker.fixed)
        return trackerCoreData
    }
    
    func getTrackersCount() -> Int {
        let request = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        request.returnsObjectsAsFaults = false
        
        do {
            let trackers = try context.fetch(request)
            return trackers.count
        } catch let error {
            print(error)
        }
        
        return 0
    }
    
    func getTracker(set: NSSet.Element) throws -> Tracker {
        guard let tracker = set as? TrackerCoreData else { throw TrackerCoreDataError.trackerCoreDataClassInvalid}
        guard let id = tracker.idTracker else { throw TrackerCoreDataError.decodingErrorInvalidId }
        guard let name = tracker.name else { throw TrackerCoreDataError.decodingErrorInvalidName }
        guard let color = tracker.color else { throw TrackerCoreDataError.decodingErrorInvalidColor }
        guard let emoji = tracker.emoji else { throw TrackerCoreDataError.decodingErrorInvalidEmoji }
        guard let shedule = tracker.shedule else { throw TrackerCoreDataError.decodingErrorInvalidShedule }
        guard let fixed = tracker.fixed else { throw TrackerCoreDataError.decodingErrorInvalidFixed }
        return Tracker(
            id: id,
            name: name,
            color: uiColorMarshalling.color(from: color),
            emoji: emoji,
            shedule: weekDaysMarshalling.stringToWeekDays(from: shedule),
            fixed: fixed.boolValue
        )
    }
    
    func deleteTracker(tracker: Tracker) {
        let request = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(
            format: "%K == %@",
            #keyPath(TrackerCoreData.idTracker),
            tracker.id as NSUUID
        )
        
        do {
            let tracker = try context.fetch(request).first ?? NSManagedObject()
            context.delete(tracker)
        } catch let error {
            print(error)
        }
        
        do {
            try context.save()
        } catch let error {
            print(error)
        }
    }
    
    func fixedTracker(tracker: Tracker) {
        let request = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(
            format: "%K == %@",
            #keyPath(TrackerCoreData.idTracker),
            tracker.id as NSUUID
        )
        
        do {
            let trackerRequest = try context.fetch(request).first
            if tracker.fixed {
                trackerRequest?.fixed = NSNumber(value: false)
            } else {
                trackerRequest?.fixed = NSNumber(value: true)
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
}

extension TrackerStore: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        delegate?.didTrackerUpdate()
    }
}
