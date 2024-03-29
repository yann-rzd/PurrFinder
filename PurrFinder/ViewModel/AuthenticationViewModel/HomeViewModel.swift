//
//  HomeViewModel.swift
//  PurrFinder
//
//  Created by Yann Rouzaud on 06/02/2023.
//

import Foundation
import MapKit


enum RootViewType {
    case authentication
    case main
}


extension HomeView {
    @MainActor class HomeViewModel: ObservableObject {
        
        init() {
            updateActiveRootType()
        }
        
        // MARK: - INTERNAL: properties
        
        @Published var activeRootType: RootViewType = .authentication
        
        var isUserLoggedIn: Bool {
            FirebaseAuthService.shared.isLoggedIn
        }
        
        
        // MARK: - INTERNAL: methods
        
        func updateActiveRootType() {
            
            switch (isUserLoggedIn) {
            case (true):
                activeRootType = .main
            case (false):
                activeRootType = .authentication
            }
        }
    }
}
