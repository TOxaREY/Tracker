//
//  Colors.swift
//  Tracker
//
//  Created by Anton Reynikov on 08.08.2023.
//

import UIKit

final class Colors {
    var darkModeBackgroundColor: UIColor = UIColor { (traits) -> UIColor in
        let isDarkMode = traits.userInterfaceStyle == .dark
        return isDarkMode ? UIColor.ypBlack : UIColor.ypWhite
    }

    var darkModeForegroundColor: UIColor = UIColor { (traits) -> UIColor in
        let isDarkMode = traits.userInterfaceStyle == .dark
        return isDarkMode ? UIColor.ypWhite : UIColor.ypBlack
    }
}


