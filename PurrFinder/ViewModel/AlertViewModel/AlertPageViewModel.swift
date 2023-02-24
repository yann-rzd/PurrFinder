//
//  AlertPageViewModel.swift
//  PurrFinder
//
//  Created by Yann Rouzaud on 24/02/2023.
//

import Foundation

extension AlertPageView {
    @MainActor class AlertPageViewModel: ObservableObject {
        @Published var showPetForm = false
        @Published var alertInProgress = false
        
        func checkIfAlertInProgress() async {
            let userUID = firestoreAuthService.getCurrentUserUID()
            alertInProgress = await firestoreService.checkIfAlertInProgress(userUID: userUID)
        }
        
        private let firestoreService = FirestoreService.shared
        private let firestoreAuthService = FirebaseAuthService.shared
    }
}
