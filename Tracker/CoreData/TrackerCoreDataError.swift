//
//  TrackerCoreDataError.swift
//  Tracker
//
//  Created by Anton Reynikov on 20.07.2023.
//

import Foundation

enum TrackerCoreDataError: Error {
    case decodingErrorInvalidId
    case decodingErrorInvalidName
    case decodingErrorInvalidColor
    case decodingErrorInvalidEmoji
    case decodingErrorInvalidShedule
}
