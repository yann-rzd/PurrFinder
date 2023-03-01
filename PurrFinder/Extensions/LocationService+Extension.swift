//
//  LocationService+Extension.swift
//  PurrFinder
//
//  Created by Yann Rouzaud on 28/02/2023.
//

import Foundation
import CoreLocation

extension LocationService: CLLocationManagerDelegate {

    /// This function is called whenever new location data is available. It updates the latitude and longitude variables according to the last received location.
    /// - parameter CLLocationManager: represent the geographical coordinates of the user.
    /// - parameter [CLLocation]:  represent the geographical coordinates of the user.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            latitude = location.coordinate.latitude
            longitude = location.coordinate.longitude
        }
    }
    
    
    /// This function checks whether the authorization status. If it is good, the startUpdatingLocation method is called.
    /// - parameter CLLocationManager: represent the geographical coordinates of the user.
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedWhenInUse {
            startUpdatingLocation()
        }
    }
}
