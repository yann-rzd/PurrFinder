//
//  UserSettingsView.swift
//  PurrFinder
//
//  Created by Yann Rouzaud on 22/02/2023.
//

import SwiftUI

struct UserSettingsView: View {
    @StateObject var userSettingsViewModel = UserSettingsViewModel()
    @Binding var isPresented: Bool
    @State private var showAlert = false
    
    var body: some View {
        
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    isPresented = false
                }) {
                    Image(systemName: "xmark")
                        .foregroundColor(Color("BluePurr"))
                        .font(.system(size: 20))
                }
            }
            .padding(.trailing, 20)
            .padding(.top, 20)
            
            Spacer()
            Button(action: {
                // Afficher un message d'alerte avec un titre, un message, deux choix "oui" et "non"
                showAlert.toggle()
            }) {
                Text("Supprimer mon compte")
                    .foregroundColor(.white)
                    .padding(.vertical)
                    .frame(width: UIScreen.main.bounds.width - 50)
            }
            .background(Color("BluePurr"))
            .cornerRadius(10)
            Spacer()
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Êtes-vous sûr de vouloir supprimer votre compte ?"), message: Text("Cette action est irréversible."), primaryButton: .destructive(Text("Oui")) {
                Task {
                    await userSettingsViewModel.deleteUser()
                }
                isPresented = false
                UserDefaults.standard.set(false, forKey: "status")
                NotificationCenter.default.post(name: NSNotification.Name("status"), object: nil)
//                HomeView()
            }, secondaryButton: .cancel(Text("Non")))
        }
    }
}

struct UserSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        let isPresented = Binding.constant(false)
        return UserSettingsView(isPresented: isPresented)
    }
}
