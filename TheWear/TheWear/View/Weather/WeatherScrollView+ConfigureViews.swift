/*
 
 Copyright © 2026 Max Reshetov, Valentina Selezneva.
 All rights reserved.
 
*/

import UIKit

extension WeatherView {
    
    func configureScrollView() {
        addSubview(scrollView)
        scrollView.matchSuperview()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.delegate = self
        scrollView.refreshControl = updateControl
        isUserInteractionEnabled = false
        scrollView.alwaysBounceVertical = true
        scrollView.contentInset = .init(top: Size.padding.xxxLarge, left: 0, bottom: 0, right: 0)
        backgroundColor = Color.weather.sunny
    }
    
    func configureContentView() {
        scrollView.addSubview(contentView)
        contentView.constraints(
            top: scrollView.top,
            bottom: scrollView.bottom(Size.padding.medium),
            centerX: scrollView.centerX,
            width: .equalTo(scrollView.width, constant: -2 * Size.padding.medium)
        )
    }
    
    func configureStatusBarSubstrateView() {
        addSubview(statusBarSubstrateView)
        statusBarSubstrateView.constraints(
            top: self.top,
            left: self.left,
            right: self.right,
            height: .equalToConstant(topSafeArea)
        )
    }
    
    func configurePartsView() {
        contentView.addSubview(partsView)
        partsView.constraints(
            top: contentView.top,
            left: contentView.left,
            width: .equalToConstant(partsSize.width)
        )
        partsViewHeightConstraint = partsView.heightAnchor.constraint(equalToConstant: partsSize.height)
        partsViewHeightConstraint.isActive = true
    }
    
    func configureAdView() {
        contentView.addSubview(adView)
        adView.constraints(
            top: isIphone ? partsView.bottom(Size.padding.small) : contentView.top,
            left: isIphone ? contentView.left : partsView.right(Size.padding.small),
            width: .equalToConstant(hoursSize.width)
        )
        adViewHeightConstraint = adView.heightAnchor.constraint(equalToConstant: 0)
        adViewHeightConstraint.isActive = true
    }
    
    func configureHoursView() {
        contentView.addSubview(hoursView)
        hoursView.constraints(
            left: isIphone ? contentView.left : partsView.right(Size.padding.small),
            width: .equalToConstant(hoursSize.width),
            height: .equalToConstant(hoursSize.height)
        )
        hoursViewTopConstraint = hoursView.topAnchor.constraint(equalTo: adView.bottomAnchor, constant: 0)
        hoursViewTopConstraint.isActive = true
    }
    
    func configureForecastView() {
        contentView.addSubview(forecastView)
        forecastView.constraints(
            top: hoursView.bottom(Size.padding.small),
            left: hoursView.left,
            width: .equalToConstant(forecastSize.width),
            height: .equalToConstant(forecastSize.height)
        )
    }
    
    func configureUnitViews() {
        configureWindView()
        configurePressureView()
        configureHumidityView()
        configureUVView()
        configureVisibilityView()
        configurePrecipitationView()
    }
    
    func configureWindView() {
        contentView.addSubview(windView)
        windView.constraints(
            top: isIphone ? forecastView.bottom(Size.padding.small) : partsView.bottom(Size.padding.small),
            left: contentView.left,
            width: .equalToConstant(unitSize.width),
            height: .equalToConstant(unitSize.height)
        )
    }
    
    func configurePressureView() {
        contentView.addSubview(pressureView)
        pressureView.constraints(
            top: windView.top,
            left: windView.right(Size.padding.small),
            width: .equalToConstant(unitSize.width),
            height: .equalToConstant(unitSize.height)
        )
    }
    
    func configureHumidityView() {
        contentView.addSubview(humidityView)
        humidityView.constraints(
            top: isIphone ? windView.bottom(Size.padding.small) : pressureView.top,
            left: isIphone ? contentView.left : pressureView.right(Size.padding.small),
            width: .equalToConstant(unitSize.width),
            height: .equalToConstant(unitSize.height)
        )
    }
    
    func configureUVView() {
        contentView.addSubview(uvView)
        uvView.constraints(
            top: isIphone ? humidityView.top : windView.bottom(Size.padding.small),
            left: isIphone ? pressureView.left : contentView.left,
            width: .equalToConstant(unitSize.width),
            height: .equalToConstant(unitSize.height)
        )
    }
    
    func configureVisibilityView() {
        contentView.addSubview(visibilityView)
        visibilityView.constraints(
            top: isIphone ? humidityView.bottom(Size.padding.small) : uvView.top,
            left: isIphone ? contentView.left : pressureView.left,
            width: .equalToConstant(unitSize.width),
            height: .equalToConstant(unitSize.height)
        )
    }
    
    func configurePrecipitationView() {
        contentView.addSubview(precipitationView)
        precipitationView.constraints(
            top: visibilityView.top,
            left: isIphone ? uvView.left : humidityView.left,
            bottom: contentView.bottom,
            width: .equalToConstant(unitSize.width),
            height: .equalToConstant(unitSize.height)
        )
    }
    
}
