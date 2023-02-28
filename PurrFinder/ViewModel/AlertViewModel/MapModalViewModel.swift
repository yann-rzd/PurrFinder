//
//  MapModalVoewModel.swift
//  PurrFinder
//
//  Created by Yann Rouzaud on 25/02/2023.
//

import Foundation

extension MapModalView {
    @MainActor class MapModalViewModel: ObservableObject {
        
        // MARK: - INTERNAL: properties
        
        @Published var ownerLatitude = 0.0
        @Published var ownerLongitude = 0.0
        
        
        // MARK: - INTERNAL: methods
        
        func getOwnerLocation() async throws {
            let userUID = firebaseAuthService.getCurrentUserUID()
            let userDTO = try await firestoreService.getUserData(userUID: userUID)
            
            guard let latitude = userDTO.locationLatitude else {
                return
            }
            
            guard let longitude = userDTO.locationLongitude else {
                return
            }
            
            ownerLatitude = stringToDoubleConvertor(stringNumber: latitude)
            ownerLongitude = stringToDoubleConvertor(stringNumber: longitude)
        }
        
        
        // MARK: - PRIVATE: properties
        
        private let firebaseAuthService = FirebaseAuthService.shared
        private let firestoreService = FirestoreService.shared
        private let storageService = StorageService.shared
        
        
        // MARK: - PRIVATE: methods
        
        private func stringToDoubleConvertor(stringNumber: String) -> Double {
            if let doubleNumber = Double(stringNumber) {
                return doubleNumber
            } else {
                return 0.0
            }
        }
    }
}
