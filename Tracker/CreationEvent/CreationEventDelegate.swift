//
//  CreationEventDelegate.swift
//  Tracker
//
//  Created by Anton Reynikov on 03.08.2023.
//

import Foundation

protocol CreationEventDelegate: AnyObject {
    var creationEvent:CreationEvent { get set }
}
