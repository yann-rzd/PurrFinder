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
        NavigationView {
            VStack {
                if homeViewModel.status {
                    NavigationTabView()
                } else {
                    ZStack {
                        NavigationLink(destination: SignUpView(show: $homeViewModel.show), isActive: $homeViewModel.show) {
                            Text("")
                        }
                        .hidden()
                        
                        LoginView(show: $homeViewModel.show)
                    }
                }
            }
            .navigationBarTitle("")
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
            .onAppear {
                NotificationCenter.default.addObserver(forName: NSNotification.Name("status"), object: nil, queue: .main) { (_) in
                    homeViewModel.status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
                }
            }
        }
    }
}
