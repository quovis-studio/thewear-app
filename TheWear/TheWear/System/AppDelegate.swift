/*
 
 Copyright © 2022 Max Reshetov, Valentina Selezneva.
 All rights reserved.
 
*/

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        NetworkService.shared.start()
        AnalyticsService.shared.configure()
        CalendarAndLocaleService.shared.updateTimePreference()
        CalendarAndLocaleService.shared.getDefaultTempUnits()
        BackgroundFetchService.shared.register()
        UD.shared.configureIfNeeded()
        AnalyticsService.shared.sendEvent(.appOpened)
        AdsService.setup()
        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {  }
    
    func applicationWillTerminate(_ application: UIApplication) {  }
    
    func applicationWillEnterForeground(_ application: UIApplication) {  }
    
    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {  }
    
}
