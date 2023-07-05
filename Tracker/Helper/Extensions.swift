//
//  Extensions.swift
//  Tracker
//
//  Created by Anton Reynikov on 16.05.2023.
//

import UIKit

extension UIColor {
    static var ypBlue: UIColor { UIColor(named: "YP Blue")! }
    static var ypWhite: UIColor { UIColor(named: "YP White")! }
    static var ypGray: UIColor { UIColor(named: "YP Gray")! }
    static var ypBlack: UIColor { UIColor(named: "YP Black")! }
    static var ypRed: UIColor { UIColor(named: "YP Red")! }
    static var ypLightGray: UIColor { UIColor(named: "YP Light Gray")! }
    static var ypBackground: UIColor { UIColor(hex: "#e6e8eb4d")! }
    static var ypBackgroundTrackersField: UIColor { UIColor(hex: "#f0f0f0ff")! }
    
    public convenience init?(hex: String) {
        let r, g, b, a: CGFloat
        
        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])
            
            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0
                
                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255
                    
                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }
        return nil
    }
}

extension UIFont {
    static var ypMedium_16: UIFont { UIFont(name: "SFPro-Medium", size: 16.0)! }
    static var ypRegular_17: UIFont { UIFont(name: "SFPro-Regular", size: 17.0)! }
    static var ypMedium_10: UIFont { UIFont(name: "SFPro-Medium", size: 10.0)! }
    static var ypBold_34: UIFont { UIFont(name: "SFPro-Bold", size: 34.0)! }
    static var ypMedium_12: UIFont { UIFont(name: "SFPro-Medium", size: 12.0)! }
    static var ypBold_19: UIFont { UIFont(name: "SFPro-Bold", size: 19.0)! }
    static var ypBold_32: UIFont { UIFont(name: "SFPro-Bold", size: 32.0)! }
}

extension UIImage {
    class func colorForNavBar(color: UIColor) -> UIImage {
        let rect = CGRectMake(0.0, 0.0, 1.0, 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
    
    func image(alpha: CGFloat) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(at: .zero, blendMode: .normal, alpha: alpha)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}

extension Int {
     func days() -> String {
         var dayString: String!
         if "1".contains("\(self % 10)") {
             dayString = "день"
             
         }
         if "234".contains("\(self % 10)") {
             dayString = "дня"
             
         }
         if "567890".contains("\(self % 10)") {
             dayString = "дней"
             
         }
         if 11...14 ~= self % 100 {
             dayString = "дней"
             
         }
         return "\(self) " + dayString
    }
}

