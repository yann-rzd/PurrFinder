//
//  AlertPageView.swift
//  PurrFinder
//
//  Created by Yann Rouzaud on 06/02/2023.
//

import SwiftUI
import CoreLocation

struct AlertPageView: View {
    @StateObject var locationViewModel = LocationViewModel()
    @StateObject var alertPageViewModel = AlertPageViewModel()
    
    
    var body: some View {
        NavigationView {
            
            if alertPageViewModel.alertInProgress {
                CurrentAlertPageView()
            } else {
                VStack {
                    Text("Push pour lancer une alerte")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(Color("BluePurr"))
                        .padding(.horizontal, 40)
                        .multilineTextAlignment(.center)
                    
                    Button(action: {
                        alertPageViewModel.showPetForm.toggle()
                    }) {
                        Image("Paw")
                            .resizable()
                            .frame(width: 300, height: 300)
                            .padding(.top, 50)
                    }
                    .sheet(isPresented: $alertPageViewModel.showPetForm) {
                        PetFormView(isPresented: $alertPageViewModel.showPetForm, alertInProgress: $alertPageViewModel.alertInProgress)
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
                await alertPageViewModel.checkIfAlertInProgress()
            }
        }
    }
}



struct AlertPageView_Previews: PreviewProvider {
    static var previews: some View {
        AlertPageView()
    }
}
