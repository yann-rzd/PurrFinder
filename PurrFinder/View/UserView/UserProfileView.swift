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
        NavigationView {
            VStack {
                
                
                
                Text("PurrFinder Profil")
                    .font(Font.custom("AmaticSC-Bold", size: 32))
                    .foregroundColor(Color("BluePurr"))
                    .padding(.top, 25)
                
                Spacer()
                
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
                
                Spacer()
                
                /// Profile information
                
                TextField("Nom", text: $userProfileViewModel.name)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 4).stroke(userProfileViewModel.isEditProfileInformation ? Color("BluePurr") : Color(.black), lineWidth: 0.5))
                    .padding(.horizontal, 20)
                    .disabled(!userProfileViewModel.isEditProfileInformation)
                
                
                
                TextField("Téléphone", text: $userProfileViewModel.phone)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 4).stroke(userProfileViewModel.isEditProfileInformation ? Color("BluePurr") : Color(.black), lineWidth: 0.5))
                    .padding(.horizontal, 20)
                    .disabled(!userProfileViewModel.isEditProfileInformation)
                
                
                /// Edit profile informations button
                ///
                Button(action: {
                    userProfileViewModel.isEditProfileInformation.toggle()
                    if !userProfileViewModel.isEditProfileInformation {
                        Task {
                            try
                            await userProfileViewModel.saveUserDataNamePhone()
                        }
                    }
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
                
                /// Signout button
                Button(action: {
                    userProfileViewModel.signOut()
                }) {
                    Text("Se déconnecter")
                        .foregroundColor(.white)
                        .padding(.vertical)
                        .frame(width: UIScreen.main.bounds.width - 50)
                }
                .background(Color("BluePurr"))
                .cornerRadius(10)
                .padding(.bottom, 25)
            }
            .task {
                do {
                    try await userProfileViewModel.getUserData()
                } catch {
                    // handle error
                }
                
            }
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink {
                        UserSettingsView()
                    } label: {
                        Image(systemName: "gearshape")
                            .resizable()
                    }

                }
            })
            .alert(isPresented: $imagePickerViewModel.presentNotAuthorizedProhibitedAlert) {
                Alert(title: Text("Pas autorisé"), message: Text("Vous avez refusé l'accès à votre galerie. Vous pouvez changer cela dans les paramètres."), dismissButton: .default(Text("Fermer")))
                
            }
            .alert(isPresented: $userProfileViewModel.alert) {
                Alert(title: Text(self.userProfileViewModel.error == "Information updated" ? "Message" : "Error"),
                      message: Text(self.userProfileViewModel.error == "Information updated" ? "Information updated successfully" : self.userProfileViewModel.error),
                      dismissButton: .default(Text(self.userProfileViewModel.error == "Information updated" ? "Ok" : "Cancel")))
            }
            .fullScreenCover(isPresented: $imagePickerViewModel.changeProfileImage) {
                ImagePicker(image: $userProfileViewModel.profileImage)
            }
        }
    }
    
    //        if userProfileViewModel.alert {
    //            UserProfileErrorView(alert: $userProfileViewModel.alert, error: $userProfileViewModel.error)
    //        }
    
    
}

struct UserProfileView_Previews: PreviewProvider {
    static var previews: some View {
        UserProfileView()
    }
}

