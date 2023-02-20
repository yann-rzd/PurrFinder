//
//  UserProfileView.swift
//  PurrFinder
//
//  Created by Yann Rouzaud on 07/02/2023.
//

import SwiftUI
import Firebase

struct UserProfileView: View {
    @StateObject private var userProfileViewModel = UserProfileViewModel()
    @StateObject var imagePickerViewModel = ImagePickerViewModel()
    
    let storageService = StorageService.shared
    
    var body: some View {
        
        VStack {
            /// Profile image and edit image button
            ZStack(alignment: .bottomTrailing) {
                ZStack {
                    if let image = userProfileViewModel.profileImage {
                        Image(uiImage: image)
                            .resizable()
                            .frame(width: 120, height: 120)
                            .clipShape(Circle())
                    } else {
                        Image(systemName: "person.crop.circle")
                            .resizable()
                            .frame(width: 120, height: 120)
                            .clipShape(Circle())
//                            .foregroundColor(Color("BluePurr"))
                    }
                }
                
                Button {
                    imagePickerViewModel.checkAuthorization()
                    
                } label: {
                    Image(systemName: "plus")
                        .frame(width: 30, height: 30)
                        .foregroundColor(Color.white)
                        .background(Color.gray)
                        .clipShape(Circle())
                }
            }
            .padding(.top, 25)
            //            .sheet(isPresented: $imagePickerViewModel.changeProfileImage) {
            //                ImagePicker(sourceType: .photoLibrary, selectedImage: $imagePickerViewModel.profileImage)
            //            }
            
            
            /// Edit profile informations button
            Button(action: {
                // Allow edit or save
            }) {
                Text(userProfileViewModel.isEditProfileInformation ? "Sauvegarder" : "Éditer")
                    .foregroundColor(.white)
                    .padding(.vertical, 5)
                    .frame(width: UIScreen.main.bounds.width - 250)
            }
            .background(Color("BluePurr"))
            .cornerRadius(10)
            .padding(.top, 25)
            
            Spacer()
            
            
            /// Profile information
            TextField("Nom", text: $userProfileViewModel.name)
                .padding()
                .background(RoundedRectangle(cornerRadius: 4).stroke(userProfileViewModel.name != "" ? Color("BluePurr") : userProfileViewModel.color, lineWidth: 2))
                .padding(.horizontal, 20)
            
            TextField("Téléphone", text: $userProfileViewModel.phone)
                .padding()
                .background(RoundedRectangle(cornerRadius: 4).stroke(userProfileViewModel.phone != "" ? Color("BluePurr") : userProfileViewModel.color, lineWidth: 2))
                .padding(.horizontal, 20)
            
            Text(userProfileViewModel.name)
            
            
            
            Spacer()
            
            
            /// Signout button
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
        .task {
            do {
                try await userProfileViewModel.getUserData()
            } catch {
                // handle error
            }
            
        }
        
        .alert(isPresented: $imagePickerViewModel.presentNotAuthorizedProhibitedAlert) {
            Alert(title: Text("Pas autorisé"), message: Text("Vous avez refusé l'accès à votre galerie. Vous pouvez changer cela dans les paramètres."), dismissButton: .default(Text("Fermer")))
            
        }
        .fullScreenCover(isPresented: $imagePickerViewModel.changeProfileImage) {
            ImagePicker(image: $userProfileViewModel.profileImage)
        }
        
    }
    
}

struct UserProfileView_Previews: PreviewProvider {
    static var previews: some View {
        UserProfileView()
    }
}

