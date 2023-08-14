//
//  AnalyticsService.swift
//  Tracker
//
//  Created by Anton Reynikov on 10.08.2023.
//

import Foundation
import YandexMobileMetrica

struct AnalyticsService {
    static func activate() {
        guard let configuration = YMMYandexMetricaConfiguration(apiKey: "ab4434ec-886e-43f3-accf-8dccb8e73a0e") else { return }
        
        YMMYandexMetrica.activate(with: configuration)
    }
    
    func report(event: Event, param: Item?) {
        var params = ["screen": "Main"]
        if param != nil {
            params.updateValue(param?.rawValue ?? String(), forKey: "item")
        }
        YMMYandexMetrica.reportEvent(event.rawValue, parameters: params, onFailure: { error in
            print("REPORT ERROR: %@", error.localizedDescription)
        })
    }
}
