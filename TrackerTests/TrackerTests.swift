//
//  TrackerTests.swift
//  TrackerTests
//
//  Created by Anton Reynikov on 04.08.2023.
//

import XCTest
import SnapshotTesting
@testable import Tracker

final class TrackerTests: XCTestCase {

    func testTrackersViewControllerLightTheme() {
        let trackersVC = TrackersViewController()
        
        assertSnapshot(matching: trackersVC, as: .image(traits: .init(userInterfaceStyle: .light)))
    }
}
