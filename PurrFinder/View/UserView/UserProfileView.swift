//
//  UserProfileView.swift
//  PurrFinder
//
//  Created by Yann Rouzaud on 07/02/2023.
//

import SwiftUI

struct UserProfileView: View {
    @StateObject private var userProfileViewModel = UserProfileViewModel()
        
        var body: some View {
            VStack {
                Text("Bienvenue sur PurrFinder !")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(Color.black.opacity(0.7))
                
                Button(action: {
                    userProfileViewModel.signOut()
                    UserDefaults.standard.set(false, forKey: "status")
                    NotificationCenter.default.post(name: NSNotification.Name("status"), object: nil)
                }) {
                    Text("Se déconnecter")
                        .foregroundColor(.white)
                        .padding(.vertical)
                        .frame(width: UIScreen.main.bounds.width - 50)
                }
                .background(Color("BluePurr"))
                .cornerRadius(10)
                .padding(.top, 25)
            }
        }
}

struct UserProfileView_Previews: PreviewProvider {
    static var previews: some View {
        UserProfileView()
    }
}
