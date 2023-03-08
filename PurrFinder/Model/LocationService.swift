//
//  LocationService.swift
//  PurrFinder
//
//  Created by Yann Rouzaud on 07/02/2023.
//

import Foundation
import CoreLocation

class LocationService: NSObject, CLLocationManagerDelegate {
    weak var delegate: LocationServiceDelegate?
    internal var locationManager: CLLocationManager = CLLocationManager()
    
    func startUpdatingLocation() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            delegate?.locationServiceDidUpdateLocation(self, latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedWhenInUse {
            startUpdatingLocation()
        }
    }
}

protocol LocationServiceDelegate: AnyObject {
    func locationServiceDidUpdateLocation(_ locationService: LocationService, latitude: Double, longitude: Double)
}
