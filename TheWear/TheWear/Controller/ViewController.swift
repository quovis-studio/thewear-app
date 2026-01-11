/*
 
 Copyright © 2026 Max Reshetov, Valentina Selezneva.
 All rights reserved.
 
*/

import UIKit
import YandexMobileAds

final class ViewController: UIViewController, AdViewDelegate {
    
    // ***
    // style
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    
    // ***
    // viewmodel
    
    var partsViewModel: [PartViewModel]?
    var hoursViewModel: [HourViewModel]?
    var unitsViewModel: [UnitViewModel]?
    var forecastViewModel: [ForecastViewModel]?
    
    
    // ***
    // view
    
    let navigationView = NavigationView()
    let weatherView = WeatherView()
    
    
    // ***
    // configure - view
    
    private func configureWeatherView() {
        view.addSubview(weatherView)
        weatherView.matchSuperview()
        weatherView.weatherDelegate = self
        weatherView.weatherFetchDelegate = self
    }
    
    private func configureNavigationView() {
        view.addSubview(navigationView)
        navigationView.constraints(
            top: view.safeArea.top(Size.padding.xxxSmall),
            left: view.left(Size.padding.medium),
            right: view.right(Size.padding.medium)
        )
        navigationView.navigationDelegate = self
    }
    
    
    // ***
    // configure - ad
    
    private func configureAd() {
        weatherView.adView.delegate = self
    }
    
    private func loadAd() {
        weatherView.adView.loadAd()
    }
    
    func adViewDidLoad(_ adView: AdView) {
        weatherView.adView.isHidden = false
        weatherView.adViewHeightConstraint.constant = ceil(weatherView.adView.adInfo?.adSize?.height ?? 0)
        weatherView.hoursViewTopConstraint.constant = Size.padding.small
        weatherView.layoutIfNeeded()
    }
    
    func adView(_ adView: AdView, didFailLoadingWithError error: Error) {
        print(error)
        weatherView.adView.isHidden = true
        weatherView.adViewHeightConstraint.constant = 0
        weatherView.hoursViewTopConstraint.constant = 0
        weatherView.layoutIfNeeded()
    }
    
    
    // ***
    // lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureWeatherView()
        configureNavigationView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        AdsService.checkTrackingPermission { [weak self] in
            self?.configureAd()
            self?.loadAd()
            LocationService.shared.configureLocationManager()
            NotificationService.shared.requestPermission()
        }
    }
    
}
