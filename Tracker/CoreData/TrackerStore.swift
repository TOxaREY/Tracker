//
//  TrackerStore.swift
//  Tracker
//
//  Created by Anton Reynikov on 20.07.2023.
//

import UIKit
import CoreData

final class TrackerStore: NSObject {
    private let uiColorMarshalling = UIColorMarshalling()
    private let weekDaysMarshalling = WeekDayMarshalling()
    
    func addTracker(tracker: Tracker, context: NSManagedObjectContext) -> TrackerCoreData {
        let trackerCoreData = TrackerCoreData(context: context)
        trackerCoreData.idTracker = tracker.id
        trackerCoreData.name = tracker.name
        trackerCoreData.color = uiColorMarshalling.hexString(from: tracker.color)
        trackerCoreData.emoji = tracker.emoji
        trackerCoreData.shedule = weekDaysMarshalling.weekDaysToString(from: tracker.shedule)
        return trackerCoreData
    }
    
    func getTracker(tracker: TrackerCoreData) throws -> Tracker {
        guard let id = tracker.idTracker else { throw TrackerCoreDataError.decodingErrorInvalidId }
        guard let name = tracker.name else { throw TrackerCoreDataError.decodingErrorInvalidName }
        guard let color = tracker.color else { throw TrackerCoreDataError.decodingErrorInvalidColor }
        guard let emoji = tracker.emoji else { throw TrackerCoreDataError.decodingErrorInvalidEmoji }
        guard let shedule = tracker.shedule else { throw TrackerCoreDataError.decodingErrorInvalidShedule }
        return Tracker(
            id: id,
            name: name,
            color: uiColorMarshalling.color(from: color),
            emoji: emoji,
            shedule: weekDaysMarshalling.stringToWeekDays(from: shedule)
        )
    }
}
