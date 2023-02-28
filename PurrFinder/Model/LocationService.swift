//
//  LocationService.swift
//  PurrFinder
//
//  Created by Yann Rouzaud on 07/02/2023.
//

import Foundation
import CoreLocation

class LocationService: NSObject, ObservableObject {
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    
    
    // MARK: - INTERNAL: properties
    
    @Published var latitude: Double = 0
    @Published var longitude: Double = 0
    
    
    // MARK: - INTERNAL: methods
    
    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
    
    
    // MARK: - PRIVATE: properties
    
    private let locationManager = CLLocationManager()
}
