//
//  AppDelegate.swift
//  Tracker
//
//  Created by Anton Reynikov on 03.05.2023.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        if #available(iOS 15, *) {
            let navigationBarAppearance = UINavigationBarAppearance()
            navigationBarAppearance.configureWithOpaqueBackground()
            navigationBarAppearance.titleTextAttributes = [
                NSAttributedString.Key.font: UIFont.ypMedium_16,
                NSAttributedString.Key.foregroundColor: UIColor.ypBlack
            ]
            navigationBarAppearance.backgroundColor = UIColor.ypWhite
            navigationBarAppearance.shadowColor = .clear
            UINavigationBar.appearance().standardAppearance = navigationBarAppearance
            UINavigationBar.appearance().compactAppearance = navigationBarAppearance
            UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
            
            let tabBarApperance = UITabBarAppearance()
            tabBarApperance.configureWithOpaqueBackground()
            tabBarApperance.backgroundImage = UIImage.colorForNavBar(color: .ypWhite)
            tabBarApperance.shadowImage = UIImage.colorForNavBar(color: UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.3))
            UITabBar.appearance().scrollEdgeAppearance = tabBarApperance
            UITabBar.appearance().standardAppearance = tabBarApperance
        } else {
            UINavigationBar.appearance().setBackgroundImage(UIImage(), for: UIBarPosition.any, barMetrics: UIBarMetrics.default)
            UINavigationBar.appearance().shadowImage = UIImage()
            UINavigationBar.appearance().tintColor = UIColor.ypWhite
            UINavigationBar.appearance().barTintColor = UIColor.ypWhite
            UINavigationBar.appearance().isTranslucent = false
            UINavigationBar.appearance().clipsToBounds = false
            UINavigationBar.appearance().backgroundColor = UIColor.ypWhite
            UINavigationBar.appearance().titleTextAttributes = [
                NSAttributedString.Key.font: UIFont.ypMedium_16,
                NSAttributedString.Key.foregroundColor: UIColor.ypBlack
            ]
            
            UITabBar.appearance().backgroundImage = UIImage.colorForNavBar(color: .ypWhite)
            UITabBar.appearance().shadowImage = UIImage.colorForNavBar(color: UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.3))
        }
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

