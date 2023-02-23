//
//  PertFormViewModel.swift
//  PurrFinder
//
//  Created by Yann Rouzaud on 22/02/2023.
//

import Foundation
import SwiftUI

extension PetFormView {
    @MainActor class PetFormViewModel: ObservableObject {
        @Published var petImage: UIImage?
        @Published var petName = ""
        @Published var petType = ""
        @Published var petBreed = ""
        @Published var petDescription = ""
        
        private func getProfileImage() async throws {
            self.petImage = try await storageService.downloadProfileImage()
        }
        
        private let firestoreService = FirestoreService.shared
        private let storageService = StorageService.shared
        private let firebaseAuthService = FirebaseAuthService.shared
        
        func createPostAlert() {
            Task {
                let uid = firebaseAuthService.getCurrentUserUID()
                let currentDate = Date()
                
                let posetAlert = PostAlert(
                    uid: uid,
                    animalName: petName,
                    animalType: petType,
                    animalBreed: petBreed,
                    animalDescription: petDescription,
                    postDate: currentDate,
                    ownerUid: uid)
                
                do {
                    try await firestoreService.createPost(post: posetAlert)
                } catch {
                    
                    print("Erreur lors de la création de l'utilisateur : \(error.localizedDescription)")
                }
                
                storageService.persistAnimalImageToStorage(image: UIImage(imageLiteralResourceName: "Cat"))
            }
        }
    }
}
