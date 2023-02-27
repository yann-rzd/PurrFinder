//
//  CurrentAlertViewModel.swift
//  PurrFinder
//
//  Created by Yann Rouzaud on 25/02/2023.
//

import Foundation
import SwiftUI
import CoreLocation

extension CurrentAlertView {
    @MainActor class CurrentAlertViewModel: ObservableObject {
        @Published var animalImage: UIImage?
        @Published var animalName = ""
        @Published var animalType = ""
        @Published var animalBreed = ""
        @Published var animalDescription = ""
        @Published var animalLostDate = ""
        @Published var alert = false
        @Published var error = ""
        @Published var showMap = false
        @Published var showAlert = false
        
        
        private func loadData() async throws {
            try await getCurrentAlertData()
        }
        
        func refresh() {
            Task {
                do {
                    try await loadData()
                } catch {
                    // handle error
                }
            }
        }
        
        func getCurrentAlertData() async throws {
            
            try await getAnimalImage()
            try await getAnimalData()
        }
        
        func deleteAlertData() async throws {
            do {
                try await deleteAnimalData()
                try await deleteAnimalImage()
            } catch {
                self.error = error.localizedDescription
                self.alert.toggle()
            }
        }
        
        func checkForPermission() async throws{
            let userUID = firebaseAuthService.getCurrentUserUID()
            
            guard await firestoreService.checkIfAlertInProgress(userUID: userUID) else {
                return
            }
            
            let userDTO = try await firestoreService.getUserData(userUID: userUID)
            let latitude = stringToDoubleConvertor(stringNumber: userDTO.locationLatitude ?? "0")
            let longitude = stringToDoubleConvertor(stringNumber: userDTO.locationLongitude ?? "0")
            let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            
            let animalDTO = try await firestoreService.getPostAlertData(userUID: userUID)
            let animalName = animalDTO.animalName
            
            let animalType = animalDTO.animalType
            
            notificationService.checkForPermission(ownerLocation: location, animalName: animalName, animalType: animalType)
        }
        
        private let firebaseAuthService = FirebaseAuthService.shared
        private let firestoreService = FirestoreService.shared
        private let storageService = StorageService.shared
        private let notificationService = Notification.shared
        
        private func getAnimalImage() async throws {
            self.animalImage = try await storageService.downloadAnimalImage()
        }
        
        private func getAnimalData() async throws {
            let userUID = firebaseAuthService.getCurrentUserUID()
            
            let animalDTO = try await firestoreService.getPostAlertData(userUID: userUID)
            animalName = animalDTO.animalName
            animalType = animalDTO.animalType
            animalBreed = animalDTO.animalBreed
            animalDescription = animalDTO.animalDescription
            animalLostDate = animalDTO.postDate
        }
        
        private func deleteAnimalData() async throws {
            let userUID = firebaseAuthService.getCurrentUserUID()
            try await firestoreService.deletePostAlert(userUID: userUID)
        }
        
        private func deleteAnimalImage() async throws {
            try await storageService.deleteAnimalImageFromStorage()
        }
        
        private func stringToDoubleConvertor(stringNumber: String) -> Double {
            if let doubleNumber = Double(stringNumber) {
                return doubleNumber
            } else {
                return 0.0
            }
        }
    }
}
