//
//  LocationViewModel.swift
//  PurrFinder
//
//  Created by Yann Rouzaud on 21/02/2023.
//

import Foundation
import CoreLocation


class LocationViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    // MARK: - INTERNAL: properties
    
    @Published var latitude: Double = 0
    @Published var longitude: Double = 0
    
    
    // MARK: - INTERNAL: methods
    
    func getUserLocation() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
        locationManager?.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            self.latitude = location.coordinate.latitude
            self.longitude = location.coordinate.longitude
        }
        
        let userUID = firebaseAuthService.getCurrentUserUID()
        
        Task {
            do {
                try await firestoreService.updateUserLocationData(userUID: userUID, latitude: latitude.description, longitude: longitude.description)
            } catch {
                self.error = error.localizedDescription
                self.alert.toggle()
            }
        }
    }
    
    
    // MARK: - PRIVATE: properties
    
    private let firestoreService = FirestoreService.shared
    private let firebaseAuthService = FirebaseAuthService.shared
    private var locationManager: CLLocationManager?
    private var error = ""
    private var alert = false
}
