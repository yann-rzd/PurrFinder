//
//  LocationViewModel.swift
//  PurrFinder
//
//  Created by Yann Rouzaud on 21/02/2023.
//

import Foundation
import CoreLocation


class LocationViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    override init() {
        super.init()
        locationService.delegate = self
    }
    
    // MARK: - INTERNAL: properties
    
    @Published var latitude: Double = 0
    @Published var longitude: Double = 0
    
    
    // MARK: - INTERNAL: methods
    
    func getUserLocation() {
        locationService.startUpdatingLocation()
    }
    
    
    // MARK: - PRIVATE: properties
    
    private let locationService = LocationService()
    private let firestoreService = FirestoreService.shared
    private let firebaseAuthService = FirebaseAuthService.shared
    private var error = ""
    private var alert = false
    
    
    // MARK: - PRIVATE: methods
    
    private func updateUserLocationData() async {
        let userUID = firebaseAuthService.getCurrentUserUID()
        guard !userUID.isEmpty else {
            self.error = "User UID is empty or nil."
            self.alert.toggle()
            return
        }
        do {
            try await firestoreService.updateUserLocationData(userUID: userUID, latitude: latitude.description, longitude: longitude.description)
        } catch {
            self.error = error.localizedDescription
            self.alert.toggle()
        }
    }
}

extension LocationViewModel: LocationServiceDelegate {
    func locationServiceDidUpdateLocation(_ locationService: LocationService, latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
        Task {
            await self.updateUserLocationData()
        }
    }
}
