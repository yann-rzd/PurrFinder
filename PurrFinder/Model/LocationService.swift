//
//  LocationService.swift
//  PurrFinder
//
//  Created by Yann Rouzaud on 07/02/2023.
//

import Foundation
import CoreLocation

protocol LocationServiceDelegate: AnyObject {
    func locationDidUpdate(to location: CLLocation)
    func locationUpdateDidFail(with error: Error)
}

class LocationService: NSObject {
    private let locationManager = CLLocationManager()
    weak var delegate: LocationServiceDelegate?

    func startUpdatingLocation() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
}

extension LocationService: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        delegate?.locationDidUpdate(to: location)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        delegate?.locationUpdateDidFail(with: error)
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            manager.startUpdatingLocation()
        case .denied, .restricted:
            delegate?.locationUpdateDidFail(with: LocationError.authorizationDenied)
        case .notDetermined:
            break
        @unknown default:
            break
        }
    }
}

enum LocationError: Error {
    case authorizationDenied
}
