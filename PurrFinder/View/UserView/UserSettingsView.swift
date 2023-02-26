//
//  UserSettingsView.swift
//  PurrFinder
//
//  Created by Yann Rouzaud on 22/02/2023.
//

import SwiftUI

struct UserSettingsView: View {
    @StateObject var userSettingsViewModel = UserSettingsViewModel()
    @State private var showAlert = false
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
        VStack {
            Button(action: {
                showAlert.toggle()
            }) {
                Text("Supprimer mon compte")
                    .foregroundColor(.white)
                    .padding(.vertical)
                    .frame(width: UIScreen.main.bounds.width - 50)
            }
            .background(Color("BluePurr"))
            .cornerRadius(10)
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Êtes-vous sûr de vouloir supprimer votre compte ?"), message: Text("Cette action est irréversible."), primaryButton: .destructive(Text("Oui")) {
                Task {
                    await userSettingsViewModel.deleteUser()
                }
                dismiss()
            }, secondaryButton: .cancel(Text("Non")))
        }
    }
}
