//
//  LocationViewModel.swift
//  PurrFinder
//
//  Created by Yann Rouzaud on 21/02/2023.
//

import Foundation
import CoreLocation


class LocationViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    private var locationManager: CLLocationManager?
    
    @Published var latitude: Double = 0
    @Published var longitude: Double = 0
    
    func getUserLocation() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
        locationManager?.startUpdatingLocation()
        
        print("LATITUDE : \(latitude)")
        print("LONGITUDE : \(longitude)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            self.latitude = location.coordinate.latitude
            self.longitude = location.coordinate.longitude
            print("LATITUDE : \(latitude)")
            print("LONGITUDE : \(longitude)")
        }
    }
}
