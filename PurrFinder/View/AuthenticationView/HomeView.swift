//
//  HomeView.swift
//  PurrFinder
//
//  Created by Yann Rouzaud on 06/02/2023.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var homeViewModel = HomeViewModel()
    
    var body: some View {
        VStack {
            switch homeViewModel.activeRootType {
            case .authentication:
                LoginView()
            case .main:
                NavigationTabView()
            }
        }
        .onAppear {
            NotificationCenter.default.addObserver(forName: NSNotification.Name("status"), object: nil, queue: .main) { (_) in
                
                homeViewModel.updateActiveRootType()
                
            }
        }
        
    }
}
