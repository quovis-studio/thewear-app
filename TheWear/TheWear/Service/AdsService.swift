/*
 
 Copyright © 2026 Max Reshetov, Valentina Selezneva.
 All rights reserved.
 
*/

import Foundation
import YandexMobileAds
import AdSupport
import AppTrackingTransparency

final class AdsService {
    
    static func setup() {
        MobileAds.initializeSDK()
    }
    
    static func checkTrackingPermission(_ completion: @escaping () -> Void) {
        if #available(iOS 14.5, *) {
            let status = ATTrackingManager.trackingAuthorizationStatus
            if status == .notDetermined {
                requestTrackingPermission { completion() }
            } else {
                completion()
            }
        } else {
            completion()
        }
    }
    
    private static func requestTrackingPermission(_ completion: @escaping () -> Void) {
        ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
            DispatchQueue.main.async { completion() }
        })
    }
    
}
