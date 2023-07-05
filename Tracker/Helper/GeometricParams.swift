//
//  GeometricParams.swift
//  Tracker
//
//  Created by Anton Reynikov on 22.05.2023.
//

import Foundation

struct GeometricParams {
    let cellCount: Int
    let leftInset: CGFloat
    let rightInset: CGFloat
    let topInset: CGFloat
    let bottomInset: CGFloat
    let cellSpacing: CGFloat
    let paddingWight: CGFloat
    
    init(cellCount: Int, leftInset: CGFloat, rightInset: CGFloat, topInset: CGFloat, bottomInset: CGFloat, cellSpacing: CGFloat) {
        self.cellCount = cellCount
        self.leftInset = leftInset
        self.rightInset = rightInset
        self.topInset = topInset
        self.bottomInset = bottomInset
        self.cellSpacing = cellSpacing
        self.paddingWight = leftInset + rightInset + CGFloat(cellCount - 1) * cellSpacing
    }
}
