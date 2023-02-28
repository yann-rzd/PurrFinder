//
//  PertFormViewModel.swift
//  PurrFinder
//
//  Created by Yann Rouzaud on 22/02/2023.
//

import Foundation
import SwiftUI

extension PetFormModalView {
    @MainActor class PetFormViewModel: ObservableObject {
        
        // MARK: - INTERNAL: properties
        
        @Published var petImage: UIImage?
        @Published var petName = ""
        @Published var petType = ""
        @Published var petBreed = ""
        @Published var petDescription = ""
        @Published var alert = false
        @Published var error = ""
        @Published var isAlertPosted = false
        
        
        // MARK: - INTERNAL: methods
        
        func createPostAlert() {
            guard !petName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
                error = PostAlertError.petNameIsEmpty.errorDescription
                alert.toggle()
                return
            }
            guard !petType.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
                error = PostAlertError.petTypeIsEmpty.errorDescription
                alert.toggle()
                return
            }
            guard !petBreed.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
                error = PostAlertError.petBreedIsEmpty.errorDescription
                alert.toggle()
                return
            }
            guard !petDescription.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
                error = PostAlertError.petDescriptionIsEmpty.errorDescription
                alert.toggle()
                return
            }
            
            if containsExtraSpaces(text: petName) {
                petName = removeExtraSpaces(text: petName)
            }
            
            if containsExtraSpaces(text: petType) {
                petType = removeExtraSpaces(text: petType)
            }
            
            if containsExtraSpaces(text: petBreed) {
                petBreed = removeExtraSpaces(text: petBreed)
            }
            
            if containsExtraSpaces(text: petDescription) {
                petDescription = removeExtraSpaces(text: petDescription)
            }
            
            savePostAlert()
        }
        
        func isAlertPosted() async {
            let userUID = firebaseAuthService.getCurrentUserUID()
            isAlertPosted = await firestoreService.checkIfAlertInProgress(userUID: userUID)
        }  
        
        // MARK: - PRIVATE: properties
        
        private let firestoreService = FirestoreService.shared
        private let storageService = StorageService.shared
        private let firebaseAuthService = FirebaseAuthService.shared
        
        
        // MARK: - PRIVATE: methods
        
        private func containsExtraSpaces(text: String) -> Bool {
            let words = text.split(separator: " ")
            let cleanedText = words.map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }.joined(separator: " ")
            return cleanedText != text
        }
        
        private func removeExtraSpaces(text: String) -> String {
            let words = text.split(separator: " ")
            let cleanedWords = words.map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            return cleanedWords.joined(separator: " ")
        }
        
        private func savePostAlert() {
            Task {
                let uid = firebaseAuthService.getCurrentUserUID()
                let currentDate = Date()
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
                let dateString = dateFormatter.string(from: currentDate)
                
                let posetAlert = PostAlert(
                    uid: uid,
                    animalName: petName,
                    animalType: petType,
                    animalBreed: petBreed,
                    animalDescription: petDescription,
                    postDate: dateString,
                    ownerUid: uid
                )
                
                do {
                    try await firestoreService.createPostAlert(post: posetAlert, userUID: uid)
                } catch {
                    
                    print("Erreur lors de la création de l'utilisateur : \(error.localizedDescription)")
                }
                
                guard let petImage = petImage else {
                    storageService.persistAnimalImageToStorage(image: UIImage(imageLiteralResourceName: "Cat"))
                    return
                }
                
                storageService.persistAnimalImageToStorage(image: petImage)
                
            }
        }
    }
}
