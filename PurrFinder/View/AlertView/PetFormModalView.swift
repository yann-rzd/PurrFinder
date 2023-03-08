//
//  PetFormView.swift
//  PurrFinder
//
//  Created by Yann Rouzaud on 22/02/2023.
//

import SwiftUI

struct PetFormModalView: View {
    @StateObject var petFormViewModel = PetFormViewModel()
    @StateObject var imagePickerViewModel = ImagePickerViewModel()
    @Binding var isPresented: Bool
    @Binding var alertInProgress: Bool
    @Environment(\.dismiss) var dismiss
    @FocusState var isInputActive: Bool
    
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
            
            //            Spacer()
            
            ZStack(alignment: .bottomTrailing) {
                ZStack {
                    if let image = petFormViewModel.petImage {
                        Image(uiImage: image)
                            .resizable()
                            .frame(width: 120, height: 120)
                            .clipShape(Circle())
                    } else {
                        Image("Cat")
                            .resizable()
                            .frame(width: 120, height: 120)
                            .clipShape(Circle())
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
            
            VStack(alignment: .leading) {
                Text("Nom de votre animal :")
                TextField("Son nom", text: $petFormViewModel.petName)
                    .padding(5)
                    .background(RoundedRectangle(cornerRadius: 4).stroke(petFormViewModel.petName != "" ? Color("BluePurr") : Color(.black), lineWidth: 0.5))
                    .submitLabel(.done)
            }
            .padding()
            
            VStack(alignment: .leading) {
                Text("Type de votre animal :")
                TextField("Chat, chient, rongeur, tortue ...", text: $petFormViewModel.petType)
                    .padding(5)
                    .background(RoundedRectangle(cornerRadius: 4).stroke(petFormViewModel.petType != "" ? Color("BluePurr") : Color(.black), lineWidth: 0.5))
                    .submitLabel(.done)
            }
            .padding()
            
            VStack(alignment: .leading) {
                Text("Race de votre animal :")
                TextField("Bengal, labrador, berger australien ...", text: $petFormViewModel.petBreed)
                    .padding(5)
                    .background(RoundedRectangle(cornerRadius: 4).stroke(petFormViewModel.petBreed != "" ? Color("BluePurr") : Color(.black), lineWidth: 0.5))
                    .submitLabel(.done)
            }
            .padding()
            
            VStack(alignment: .leading) {
                Text("Description de votre animal :")
                TextEditor(text: $petFormViewModel.petDescription)
                    .padding(5)
                    .frame(minHeight: 100, maxHeight: .infinity)
                    .background(RoundedRectangle(cornerRadius: 4).stroke(petFormViewModel.petDescription != "" ? Color("BluePurr") : Color(.black), lineWidth: 0.5))
                    .toolbar {
                        ToolbarItemGroup(placement: .keyboard) {
                            Spacer()
                            
                            Button("Done") {
                                isInputActive = false
                            }
                        }
                    }
                    
            }
            .padding()
            .focused($isInputActive)
            
            
            Button(action: {
                Task {
                    petFormViewModel.createPostAlert()
                    await petFormViewModel.isAlertPosted()
                    await Task.sleep(1 * NSEC_PER_SEC)
                    
                    if petFormViewModel.isAlertPosted {
                        try await petFormViewModel.checkForPermission()
                        alertInProgress = true
                        isPresented = false
                    }
                    
                }
            }) {
                Text("Envoyer l'alerte")
                    .foregroundColor(.white)
                    .padding(.vertical)
                    .frame(width: UIScreen.main.bounds.width - 50)
            }
            .background(Color("BluePurr"))
            .cornerRadius(10)
            .padding(.top, 25)
        }
        .ignoresSafeArea(.keyboard)
        .fullScreenCover(isPresented: $imagePickerViewModel.changeProfileImage) {
            AnimalImagePicker(image: $petFormViewModel.petImage)
        }
        .alert(isPresented: $petFormViewModel.alert) {
            Alert(title: Text("Erreur"), message: Text(petFormViewModel.error), dismissButton: .cancel())
        }
        .onTapGesture {
            hideKeyboard()
        }
    }
    
        
    
}



