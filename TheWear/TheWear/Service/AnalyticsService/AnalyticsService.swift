/*
 
 Copyright © 2022 Max Reshetov, Valentina Selezneva.
 All rights reserved.
 
*/

import Foundation
import AppMetricaCore

class AnalyticsService {
    
    static let shared = AnalyticsService()
    
    func configure() {
        guard let configuration = AppMetricaConfiguration(apiKey: getAPIKey()) else { return }
        AppMetrica.activate(with: configuration)
    }
    
    private func getAPIKey() -> String {
        if let apiKey = Bundle.main.infoDictionary?["METRICA_API_KEY"] as? String {
            return apiKey
        } else {
            return ""
        }
    }
    
    func sendEvent(_ event: Event) {
        #if DEBUG
        print("event \(event) sent")
        #else
        AppMetrica.reportEvent(name: event.rawValue)
        #endif
    }
    
    private init() {  }
    
}
