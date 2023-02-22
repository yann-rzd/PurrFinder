//
//  PetFormView.swift
//  PurrFinder
//
//  Created by Yann Rouzaud on 22/02/2023.
//

import SwiftUI

struct PetFormView: View {
    @StateObject var petFormViewModel = PetFormViewModel()
    @StateObject var imagePickerViewModel = ImagePickerViewModel()
    @Binding var isPresented: Bool
    
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
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 4).stroke(petFormViewModel.petName != "" ? Color("BluePurr") : Color(.black), lineWidth: 0.5))
            }
            .padding()
            
            VStack(alignment: .leading) {
                Text("Type de votre animal :")
                TextField("Chat, chient, rongeur, tortue ...", text: $petFormViewModel.petType)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 4).stroke(petFormViewModel.petName != "" ? Color("BluePurr") : Color(.black), lineWidth: 0.5))
            }
            .padding()
            
            VStack(alignment: .leading) {
                Text("Race de votre animal :")
                TextField("Bengal, labrador, berger australien ...", text: $petFormViewModel.petBreed)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 4).stroke(petFormViewModel.petName != "" ? Color("BluePurr") : Color(.black), lineWidth: 0.5))
            }
            .padding()
            
            VStack(alignment: .leading) {
                Text("Description de votre animal :")
                TextEditor(text: $petFormViewModel.petDescription)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 4).stroke(petFormViewModel.petName != "" ? Color("BluePurr") : Color(.black), lineWidth: 0.5))
            }
            .padding()
            
            Button(action: {
                Task {
                    // Enregistrer l'alerte et envoyer l'alerte
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
            
            Spacer()
        }
        .fullScreenCover(isPresented: $imagePickerViewModel.changeProfileImage) {
            ImagePicker(image: $petFormViewModel.petImage)
        }
    }
}

struct PetFormView_Previews: PreviewProvider {
    static var previews: some View {
        let isPresented = Binding.constant(false)
        PetFormView(isPresented: isPresented)
    }
}
