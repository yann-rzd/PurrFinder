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
            HStack {
                Spacer()
                Button(action: {
                    dismiss()
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
                dismiss()
                
//                UserDefaults.standard.set(false, forKey: "status")
//                NotificationCenter.default.post(name: NSNotification.Name("status"), object: nil)
                
            }, secondaryButton: .cancel(Text("Non")))
        }
    }
}

struct UserSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        let isPresented = Binding.constant(false)
        return UserSettingsView()
    }
}
