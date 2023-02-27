//
//  AlertPageView.swift
//  PurrFinder
//
//  Created by Yann Rouzaud on 06/02/2023.
//

import SwiftUI
import CoreLocation

struct PostAlertView: View {
    @StateObject var locationViewModel = LocationViewModel()
    @StateObject var viewModel = PostAlertViewModel()
    
    
    var body: some View {
        NavigationView {
            
            if viewModel.alertInProgress {
                CurrentAlertView(alertInProgress: $viewModel.alertStillInProgressResponse)
            } else {
                VStack {
                    Text("Push pour lancer une alerte")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(Color("BluePurr"))
                        .padding(.horizontal, 40)
                        .multilineTextAlignment(.center)
                    
                    Button(action: {
                        viewModel.showPetForm.toggle()
                    }) {
                        Image("Paw")
                            .resizable()
                            .frame(width: 300, height: 300)
                            .padding(.top, 50)
                    }
                    .sheet(isPresented: $viewModel.showPetForm) {
                        PetFormModalView(isPresented: $viewModel.showPetForm, alertInProgress: $viewModel.alertInProgress)
                    }
                    
                    Text("Les utilisateurs dans la zone seront alertés et pourrons vous contacter en cas d'informations")
                        .foregroundColor(Color("BluePurr"))
                        .padding(.horizontal, 50)
                        .padding(.top, 20)
                        .multilineTextAlignment(.center)
                }
                .onAppear() {
                    locationViewModel.getUserLocation()
                }
            }
            
        }
        .onAppear() {
            Task {
                await viewModel.checkIfAlertInProgress()
            }
            viewModel.requestNotificationAuthorization()
        }
        .onChange(of: viewModel.alertStillInProgressResponse) { newValue in
            Task {
                await viewModel.checkIfAlertInProgress()
                viewModel.alertStillInProgressResponse = true
            }
        }
    }
}



struct AlertPageView_Previews: PreviewProvider {
    static var previews: some View {
        PostAlertView()
    }
}
