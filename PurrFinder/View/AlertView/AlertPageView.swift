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
    @State private var showPetForm = false
    
    var body: some View {
        
        VStack {
            Text("Push pour lancer une alerte")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(Color("BluePurr"))
                .padding(.horizontal, 40)
                .multilineTextAlignment(.center)
            
            Button(action: {
                showPetForm.toggle()
            }) {
                Image("Paw")
                    .resizable()
                    .frame(width: 300, height: 300)
                    .padding(.top, 50)
            }
            .sheet(isPresented: $showPetForm) {
                PetFormView(isPresented: $showPetForm)
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
    
    struct AlertPageView_Previews: PreviewProvider {
        static var previews: some View {
            AlertPageView()
        }
    }
}
