//
//  TabBarController.swift
//  Tracker
//
//  Created by Anton Reynikov on 15.05.2023.
//

import UIKit

final class TabBarController: UITabBarController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let trackersViewController = UINavigationController(rootViewController: TrackersViewController())
        let statisticViewController = UINavigationController(rootViewController: StatisticViewController())

        trackersViewController.tabBarItem = UITabBarItem(
            title: "Трекеры",
            image: UIImage(named: "tab_trackers_active"),
            selectedImage: nil
            )
        
        statisticViewController.tabBarItem = UITabBarItem(
            title: "Статистика",
            image: UIImage(named: "tab_statistic_inactive"),
            selectedImage: nil
            )
        let fontAttributes = [NSAttributedString.Key.font: UIFont.ypMedium_10]
        UITabBarItem.appearance().setTitleTextAttributes(fontAttributes, for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([.foregroundColor: UIColor.ypBlue], for: .selected)
        self.tabBar.unselectedItemTintColor = .ypGray
        self.tabBar.backgroundImage = UIImage.colorForNavBar(color: .ypWhite)
        self.tabBar.shadowImage = UIImage.colorForNavBar(color: .ypGray)
        self.viewControllers = [trackersViewController, statisticViewController]
    }
}
