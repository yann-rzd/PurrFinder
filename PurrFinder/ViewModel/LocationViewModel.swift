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
    
    private var locationUpdateTimer: Timer?
    
    // MARK: - INTERNAL: methods
    
    func getUserLocation() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
        locationManager?.startUpdatingLocation()

        // Schedule location updates every 10 minutes
        locationUpdateTimer = Timer.scheduledTimer(withTimeInterval: 600, repeats: true) { [weak self] _ in
            self?.updateUserLocation()
        }
    }
    
    func updateUserLocation() {
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
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            getUserLocation()
        case .denied, .restricted, .notDetermined:
            cancelLocationUpdateTimer()
        @unknown default:
            break
        }
    }
    
    private func cancelLocationUpdateTimer() {
        locationUpdateTimer?.invalidate()
        locationUpdateTimer = nil
    }
    
    
    // MARK: - PRIVATE: properties
    
    private let firestoreService = FirestoreService.shared
    private let firebaseAuthService = FirebaseAuthService.shared
    private var locationManager: CLLocationManager?
    private var error = ""
    private var alert = false
}
