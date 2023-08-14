//
//  TabBarController.swift
//  Tracker
//
//  Created by Anton Reynikov on 15.05.2023.
//

import UIKit

final class TabBarController: UITabBarController {
    private let colors = Colors()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let trackersViewController = UINavigationController(rootViewController: TrackersViewController())
        let statisticViewController = UINavigationController(rootViewController: StatisticViewController())
        
        trackersViewController.tabBarItem = UITabBarItem(
            title: NSLocalizedString(
                "trackers.title",
                comment: "Title trackers"
            ),
            image: UIImage(named: "tab_trackers_active"),
            selectedImage: nil
        )
        
        statisticViewController.tabBarItem = UITabBarItem(
            title: NSLocalizedString(
                "statistics.title",
                comment: "Title statistics"
            ),
            image: UIImage(named: "tab_statistic_inactive"),
            selectedImage: nil
        )
        let fontAttributes = [NSAttributedString.Key.font: UIFont.ypMedium_10]
        UITabBarItem.appearance().setTitleTextAttributes(fontAttributes, for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([.foregroundColor: UIColor.ypBlue], for: .selected)
        self.tabBar.unselectedItemTintColor = .ypGray
        setTabBarUserInterfaceStyle()
        self.viewControllers = [trackersViewController, statisticViewController]
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        setTabBarUserInterfaceStyle()
    }
    
    private func setTabBarUserInterfaceStyle() {
        switch traitCollection.userInterfaceStyle {
        case .light, .unspecified:
            if #available(iOS 15, *) {
            } else {
                self.tabBar.backgroundImage = UIImage.colorForTabBar(color: colors.darkModeBackgroundColor)
                self.tabBar.shadowImage = UIImage.colorForTabBar(color: .ypGray)
            }
        case .dark:
            if #available(iOS 15, *) {
            } else {
                self.tabBar.backgroundImage = UIImage.colorForTabBar(color: colors.darkModeBackgroundColor)
                self.tabBar.shadowImage = UIImage.colorForTabBar(color: UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.3))
            }
        @unknown default:
            fatalError()
        }
    }
}
