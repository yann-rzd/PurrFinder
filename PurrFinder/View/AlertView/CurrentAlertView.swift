//
//  CurrentAlertPageView.swift
//  PurrFinder
//
//  Created by Yann Rouzaud on 24/02/2023.
//

import SwiftUI

struct CurrentAlertView: View {
    @StateObject var viewModel = CurrentAlertViewModel()
    @Binding var alertInProgress: Bool
    @Environment(\.dismiss) var dismiss
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        
        VStack {
            Text("Mon alerte en cours")
                .font(Font.custom("AmaticSC-Bold", size: 32))
                .foregroundColor(Color("BluePurr"))
                .padding(.top, 25)
            
            VStack {
                
                if let image = viewModel.animalImage {
                    Image(uiImage: image)
                        .resizable()
                        .frame(width: 120, height: 120)
                        .clipShape(Circle())
                } else {
                    Image(uiImage: UIImage(imageLiteralResourceName: "Cat"))
                        .resizable()
                        .frame(width: 120, height: 120)
                        .clipShape(Circle())
                }
                
                Text(viewModel.animalName)
                    .foregroundColor(.white)
                    .fontWeight(.heavy)
                    .font(.system(size: 24))
                    .tracking(5)
                
                Text(viewModel.animalType)
                    .foregroundColor(.white)
                    .fontWeight(.medium)
                    .font(.system(size: 24))
                    .tracking(5)
                
                Text(viewModel.animalBreed)
                    .foregroundColor(.white)
                    .fontWeight(.medium)
                    .font(.system(size: 20))
                    .tracking(5)
                
                ScrollView {
                    Text(viewModel.animalDescription)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .multilineTextAlignment(.center)
                }
                .padding(.top, 10)
                .padding(.bottom, 10)
                .padding(.horizontal, 25)
                .frame(minHeight: 100, maxHeight: .infinity)
                
                Text("Perdue le " + viewModel.animalLostDate.prefix(10) + " à " + viewModel.animalLostDate.suffix(8))
                    .foregroundColor(.white)
                    .fontWeight(.medium)
                    .font(.system(size: 20))
                    .multilineTextAlignment(.center)
                    .padding(.top, 10)
                
                HStack {
                    Text("Voir la localisation")
                        .foregroundColor(.white)
                        .fontWeight(.medium)
                        .font(.system(size: 20))
                    Button(action: {
                        viewModel.showMap = true
                    }) {
                        Image(systemName: "map.fill")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .foregroundColor(.white)
                    }
                }
                .padding(.top, 20)
            }
            .frame(width: UIScreen.main.bounds.width - 50)
            .padding(.top, 25)
            .padding(.bottom, 25)
            .background(Color.blue.opacity(0.5))
            .cornerRadius(30)
            
            Button(action: {
                viewModel.showAlert.toggle()
            }) {
                Text("Clôturer l'alerte")
                    .foregroundColor(.white)
                    .padding(.vertical)
                    .frame(width: UIScreen.main.bounds.width - 50)
            }
            .background(Color("BluePurr"))
            .cornerRadius(10)
            .padding(.top, 25)
            .padding(.bottom, 25)
        }
        
        .fullScreenCover(isPresented: $viewModel.showMap, content: {
            MapModalView(isPresented: $viewModel.showMap)
        })
        .task {
            do {
                try await viewModel.getCurrentAlertData()
            } catch {
                // handle error
            }
        }
        .alert(isPresented: $viewModel.showAlert) {
            Alert(title: Text("Êtes-vous sûr de vouloir supprimer l'alerte ?"), message: Text("Cette action est irréversible."), primaryButton: .destructive(Text("Oui")) {
                Task {
                    try await viewModel.deleteAlertData()
                    alertInProgress = false
                }
                
                dismiss()
            }, secondaryButton: .cancel(Text("Non")))
        }
    }
}
