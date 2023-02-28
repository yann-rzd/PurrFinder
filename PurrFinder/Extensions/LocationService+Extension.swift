//
//  LocationService+Extension.swift
//  PurrFinder
//
//  Created by Yann Rouzaud on 28/02/2023.
//

import Foundation
import CoreLocation

extension LocationService: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            latitude = location.coordinate.latitude
            longitude = location.coordinate.longitude
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
            if manager.authorizationStatus == .authorizedWhenInUse {
                startUpdatingLocation()
            }
        }
}
