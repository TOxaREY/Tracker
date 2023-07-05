//
//  TrackersViewControllerDelegate.swift
//  Tracker
//
//  Created by Anton Reynikov on 24.05.2023.
//

import Foundation

protocol TrackersViewControllerDelegate: AnyObject {
    var categories: [TrackerCategory] { get set }
    func checkDateAndReloadTrackersCollectionView()
}
