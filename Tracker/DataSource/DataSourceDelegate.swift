//
// DataSourceDelegate.swift
//  Tracker
//
//  Created by Anton Reynikov on 22.05.2023.
//

import Foundation

protocol DataSourceDelegate: AnyObject {
    func setDataSource()
    var creationEvent: CreationEvent { get set }
}
