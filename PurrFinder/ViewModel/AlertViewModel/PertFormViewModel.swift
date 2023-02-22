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
    }
}
