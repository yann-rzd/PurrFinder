//
//  CurrentAlertViewModel.swift
//  PurrFinder
//
//  Created by Yann Rouzaud on 25/02/2023.
//

import Foundation
import SwiftUI

extension CurrentAlertView {
    @MainActor class CurrentAlertViewModel: ObservableObject {
        @Published var animalImage: UIImage?
        @Published var animalName = ""
        @Published var animalType = ""
        @Published var animalBreed = ""
        @Published var animalDescription = ""
        @Published var animalLostDate = ""
//        @Published var ownerLatitude = 0.0
//        @Published var ownerLongitude = 0.0
        
        
        func getCurrentAlertData() async throws {
            
            try await getAnimalImage()
            try await getAnimalData()
//            try await getOwnerLocation()
        }
        
        private let firebaseAuthService = FirebaseAuthService.shared
        private let firestoreService = FirestoreService.shared
        private let storageService = StorageService.shared
        
        private func getAnimalImage() async throws {
            self.animalImage = try await storageService.downloadAnimalImage()
        }
        
        private func getAnimalData() async throws {
            let userUID = firebaseAuthService.getCurrentUserUID()
            
            let animalDTO = try await firestoreService.getPostAlertData(userUID: userUID)
            print("ANIMAL DTO : \(animalDTO)")
            animalName = animalDTO.animalName
            animalType = animalDTO.animalType
            animalBreed = animalDTO.animalBreed
            animalDescription = animalDTO.animalDescription
            animalLostDate = animalDTO.postDate
        }
        
//        private func getOwnerLocation() async throws {
//            let userUID = firebaseAuthService.getCurrentUserUID()
//            let userDTO = try await firestoreService.getUserData(userUID: userUID)
//            
//            guard let latitude = userDTO.locationLatitude else {
//                return
//            }
//            
//            guard let longitude = userDTO.locationLongitude else {
//                return
//            }
//            
//            ownerLatitude = stringToDoubleConvertor(stringNumber: latitude)
//            ownerLongitude = stringToDoubleConvertor(stringNumber: longitude)
//            
//            print("OWNER LATITUDE : \(ownerLatitude)")
//            print("OWNER LONGITUDE : \(ownerLongitude)")
//        }
//        
//        private func stringToDoubleConvertor(stringNumber: String) -> Double {
//            if let doubleNumber = Double(stringNumber) {
//                return doubleNumber
//            } else {
//                return 0.0
//            }
//        }
    }
}
