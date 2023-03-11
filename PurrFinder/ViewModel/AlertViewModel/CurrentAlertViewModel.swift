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
        
        // MARK: - INTERNAL: properties
        
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
        
        
        // MARK: - INTERNAL: methods
        
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
        
        
        // MARK: - PRIVATE: properties
        
        private let firebaseAuthService = FirebaseAuthService.shared
        private let firestoreService = FirestoreService.shared
        private let storageService = StorageService.shared
        private let notificationService = NotificationService.shared
        
        
        // MARK: - PRIVATE: methods
        
        private func getAnimalImage() async throws {
            let userUID = firebaseAuthService.getCurrentUserUID()
            self.animalImage = try await storageService.downloadAnimalImage(userUID: userUID)
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
            let userUID = firebaseAuthService.getCurrentUserUID()
            try await storageService.deleteAnimalImageFromStorage(userUID: userUID)
        }
        
        private func loadData() async throws {
            try await getCurrentAlertData()
        }
    }
}
