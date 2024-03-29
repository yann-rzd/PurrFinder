//
//  AlertPageViewModel.swift
//  PurrFinder
//
//  Created by Yann Rouzaud on 24/02/2023.
//

import Foundation

extension PostAlertView {
    @MainActor class PostAlertViewModel: ObservableObject {
        
        // MARK: - INTERNAL: properties
        
        @Published var showPetForm = false
        @Published var alertInProgress = false
        @Published var alertStillInProgressResponse = true
        
        
        // MARK: - INTERNAL: methods
        
        func checkIfAlertInProgress() async {
            let userUID = firestoreAuthService.getCurrentUserUID()
            alertInProgress = await firestoreService.checkIfAlertInProgress(userUID: userUID)
        }
        
        func requestNotificationAuthorization() {
            notificationService.requestNotificationAuthorization()
        }
        
        // MARK: - PRIVATE: properties
        
        private let firestoreService = FirestoreService.shared
        private let firestoreAuthService = FirebaseAuthService.shared
        private let notificationService = NotificationService.shared
    }
}
