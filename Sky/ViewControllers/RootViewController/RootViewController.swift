//
//  ViewController.swift
//  Sky
//
//  Created by 夏忠胜 on 2019/1/23.
//  Copyright © 2019 MrXia. All rights reserved.
//

import UIKit
import CoreLocation

class RootViewController: UIViewController {
    
    private let segueCurrentWeather = "SegueCurrentWeather"
    var currentWeatherViewController: CurrentWeatherViewController!
    
    private var currentLocation: CLLocation? {
        didSet {
            fetchCity()
            fetchWeather()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupActiveNotification()
        
    }

    private func fetchWeather() {
        guard let currentLocation = currentLocation else { return }
        
        let lat = currentLocation.coordinate.latitude
        let lon = currentLocation.coordinate.longitude
        
        WeatherDataManager.shared.weatherDataAt(latitude: lat, longitude: lon, completion: { response, error in
            if let error = error {
                dump(error)
            } else if let response = response {
                self.currentWeatherViewController.viewModel?.weather = response
            }
        })
    }
    
    private func fetchCity() {
        guard let currentLocation = currentLocation else { return }
        
        CLGeocoder().reverseGeocodeLocation(currentLocation) { placemarks, error in
            if let error = error {
                dump(error)
            } else if let city = placemarks?.first?.locality {
                let location = Location(name: city,
                                        latitude: currentLocation.coordinate.latitude,
                                        longitude: currentLocation.coordinate.longitude)
                self.currentWeatherViewController.viewModel?.location = location
            }
        }
    }

    private func setupActiveNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(RootViewController.applicationDidBecomeActive(notification:)),
                                               name: UIApplication.didBecomeActiveNotification,
                                               object: nil)
    }
    
    @objc func applicationDidBecomeActive(notification: Notification) {
        requestLocation()
    }
    
    
    // 申请用户权限
    private func requestLocation() {
        locationManager.delegate = self
        
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            locationManager.requestLocation()
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    private lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.distanceFilter = 1000
        manager.desiredAccuracy = 1000
        return manager
    }()
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        switch identifier {
        case segueCurrentWeather:
            guard let destination = segue.destination as? CurrentWeatherViewController else {
                fatalError("Invalid destination view controller!")
            }
            destination.delegate = self
            destination.viewModel = CurrentWeatherViewModel()
            currentWeatherViewController = destination
        default:
            break
        }
    }
}

extension RootViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            currentLocation = location
            manager.delegate = nil
            manager.stopUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            manager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        dump(error)
    }
}

extension RootViewController: CurrentWeatherViewControllerDelegate {
    func locationButtonPressed(controller: CurrentWeatherViewController) {
        print("Open locations.")
    }
    
    func settingsButtonPressed(controlled: CurrentWeatherViewController) {
        print("Open Settings")
    }
}

