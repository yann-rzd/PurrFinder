//
//  UserProfileView.swift
//  PurrFinder
//
//  Created by Yann Rouzaud on 07/02/2023.
//

import SwiftUI
import Photos

struct UserProfileView: View {
    @StateObject private var userProfileViewModel = UserProfileViewModel()
    @StateObject var imagePickerViewModel = ImagePickerViewModel()
    @State var presentNotAuthorizedProhibitedAlert = false
    
    @State private var authorizationStatus = PHPhotoLibrary.authorizationStatus()
    
    @State var changeProfileImage = false
//    @State var imageSelected = UIImage()

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
                    self.checkAuthorization()
                } label: {
                    Image(systemName: "plus")
                        .frame(width: 30, height: 30)
                        .foregroundColor(Color.white)
                        .background(Color.gray)
                        .clipShape(Circle())
                }
                
            }
            .sheet(isPresented: $changeProfileImage) {
                ImagePicker(sourceType: .photoLibrary, selectedImage: $imagePickerViewModel.image)
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
        .alert(isPresented: $presentNotAuthorizedProhibitedAlert) {
            Alert(title: Text("Pas autorisé"), message: Text("Vous avez refusé l'accès à votre galerie. Vous pouvez changer cela dans les paramètres."), dismissButton: .default(Text("Fermer")))
        }
    }
    
    func checkAuthorization() {
        authorizationStatus = PHPhotoLibrary.authorizationStatus()
        switch authorizationStatus {
        case .notDetermined, .restricted, .denied:
            requestAccess()
        case .authorized, .limited:
            changeProfileImage = true
        default:
            break
        }
        
    }
    
    
    func requestAccess() {
        PHPhotoLibrary.requestAuthorization { (status) in
            self.authorizationStatus = status
            switch status {
            case .authorized:
                changeProfileImage = true
            default:
                authorizationStatus = status
                self .presentNotAuthorizedProhibitedAlert = true
            }
        }
    }
}

struct UserProfileView_Previews: PreviewProvider {
    static var previews: some View {
        UserProfileView()
    }
}
