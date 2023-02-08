//
//  UserProfileView.swift
//  PurrFinder
//
//  Created by Yann Rouzaud on 07/02/2023.
//

import SwiftUI

struct UserProfileView: View {
    @StateObject private var userProfileViewModel = UserProfileViewModel()
    @StateObject var imagePickerViewModel = ImagePickerViewModel()

    

    var body: some View {
        VStack {
            ZStack(alignment: .bottomTrailing) {
                ZStack {
                    if let image = imagePickerViewModel.image {
                        Image(uiImage: image)
                            .resizable()
                            .frame(width: 120, height: 120)
                            .clipShape(Circle())
                    } else {
                        Image("Profile")
                            .resizable()
                            .frame(width: 120, height: 120)
                            .clipShape(Circle())
                    }
                }
                
                Button {
                    imagePickerViewModel.source = .library
                    imagePickerViewModel.showPhotoPicker()
                } label: {
                    Image(systemName: "plus")
                        .frame(width: 30, height: 30)
                        .foregroundColor(Color.white)
                        .background(Color.gray)
                        .clipShape(Circle())
                }
                
            }
            .sheet(isPresented: $imagePickerViewModel.showPicker) {
                ImagePicker(sourceType: imagePickerViewModel.source == .library ? .photoLibrary : .camera, selectedImage: $imagePickerViewModel.image)
                    .ignoresSafeArea()
            }
            
            Text("Bienvenue sur PurrFinder !")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(Color.black.opacity(0.7))
                .padding(.top, 200)
            
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
