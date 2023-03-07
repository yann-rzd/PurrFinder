//
//  LocationViewModel.swift
//  PurrFinder
//
//  Created by Yann Rouzaud on 21/02/2023.
//

import Foundation
import CoreLocation


class LocationViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    @Published var latitude: Double = 0
    @Published var longitude: Double = 0
    
    private let locationService = LocationService()
    
    func getUserLocation() {
        locationService.startUpdatingLocation()
    }
    
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
    
    private let firestoreService = FirestoreService.shared
    private let firebaseAuthService = FirebaseAuthService.shared
    private var error = ""
    private var alert = false
    
    override init() {
        super.init()
        locationService.delegate = self
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
