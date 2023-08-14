//
//  TrackerTests.swift
//  TrackerTests
//
//  Created by Anton Reynikov on 08.08.2023.
//

import XCTest
import SnapshotTesting
@testable import Tracker

final class TrackerTests: XCTestCase {

    func testTrackersViewControllerLightTheme() {
        let trackersVC = TrackersViewController()
        
        assertSnapshot(matching: trackersVC, as: .image(traits: .init(userInterfaceStyle: .light)))
    }
    
    func testTabBarControllerLightTheme() {
        let tabBarController = TabBarController()
        
        assertSnapshot(matching: tabBarController, as: .image(traits: .init(userInterfaceStyle: .light)))
    }
    
    func testTrackersViewControllerDarkTheme() {
        let trackersVC = TrackersViewController()
        
        assertSnapshot(matching: trackersVC, as: .image(traits: .init(userInterfaceStyle: .dark)))
    }
    
    func testTabBarControllerDarkTheme() {
        let tabBarController = TabBarController()
        
        assertSnapshot(matching: tabBarController, as: .image(traits: .init(userInterfaceStyle: .dark)))
    }
}
