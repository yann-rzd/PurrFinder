//
//  SignUpView.swift
//  PurrFinder
//
//  Created by Yann Rouzaud on 06/02/2023.
//

import SwiftUI

struct SignUpView: View {
    @StateObject private var signUpViewModel = SignUpViewModel()
    @Binding var show: Bool
    @FocusState var isInputActive: Bool
    
    var body: some View {
        ZStack {
            VStack {
                Image("Logo")
                    .resizable()
                    .frame(width: 50, height: 50)
                
                Text("PurrFinder")
                    .font(Font.custom("AmaticSC-Bold", size: 24))
                    .foregroundColor(Color("BluePurr"))
                
                Text("S'incrire")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(signUpViewModel.color)
                    .padding(.top, 35)
                
                TextField("Nom", text: $signUpViewModel.name)
                    .textInputAutocapitalization(.never)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 4).stroke(signUpViewModel.email != "" ? Color("BluePurr") : signUpViewModel.color, lineWidth: 2))
                    .padding(.top, 25)
                    .submitLabel(.done)
                    .focused($isInputActive)
                
                TextField("Téléphone", text: $signUpViewModel.phone)
                    .textInputAutocapitalization(.never)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 4).stroke(signUpViewModel.email != "" ? Color("BluePurr") : signUpViewModel.color, lineWidth: 2))
                    .padding(.top, 25)
                    .keyboardType(.numberPad)
                    .focused($isInputActive)
                    .toolbar {
                        ToolbarItemGroup(placement: .keyboard) {
                            Spacer()
                            Button("Done") {
                                isInputActive = false
                            }
                        }
                    }
                
                TextField("Email", text: $signUpViewModel.email)
                    .textInputAutocapitalization(.never)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 4).stroke(signUpViewModel.email != "" ? Color("BluePurr") : signUpViewModel.color, lineWidth: 2))
                    .padding(.top, 25)
                    .keyboardType(.emailAddress)
                    .submitLabel(.done)
                    .focused($isInputActive)
                
                HStack(spacing: 15) {
                    VStack {
                        if signUpViewModel.visible {
                            TextField("Mot de passe", text: $signUpViewModel.pass)
                                .textInputAutocapitalization(.never)
                                .submitLabel(.done)
                                .focused($isInputActive)
                        } else {
                            SecureField("Mot de passe", text: $signUpViewModel.pass)
                                .textInputAutocapitalization(.never)
                                .submitLabel(.done)
                                .focused($isInputActive)
                        }
                    }
                    
                    Button(action: {
                        signUpViewModel.visible.toggle()
                    }) {
                        Image(systemName: signUpViewModel.visible ? "eye.slash.fill" : "eye.fill")
                            .foregroundColor(signUpViewModel.color)
                    }
                }
                
                .padding()
                .background(RoundedRectangle(cornerRadius: 4).stroke(signUpViewModel.pass != "" ? Color("BluePurr") : signUpViewModel.color, lineWidth: 2))
                .padding(.top, 25)
                
                HStack(spacing: 15) {
                    VStack {
                        if signUpViewModel.revisible {
                            TextField("Re-entre", text: $signUpViewModel.repass)
                                .textInputAutocapitalization(.never)
                                .submitLabel(.done)
                                .focused($isInputActive)
                        } else {
                            SecureField("Re-entre", text: $signUpViewModel.repass)
                                .textInputAutocapitalization(.never)
                                .submitLabel(.done)
                                .focused($isInputActive)
                        }
                    }
                    
                    Button(action: {
                        signUpViewModel.revisible.toggle()
                    }) {
                        Image(systemName: signUpViewModel.revisible ? "eye.slash.fill" : "eye.fill")
                            .foregroundColor(signUpViewModel.color)
                    }
                }
                
                .padding()
                .background(RoundedRectangle(cornerRadius: 4).stroke(signUpViewModel.repass != "" ? Color("BluePurr") : signUpViewModel.color, lineWidth: 2))
                .padding(.top, 25)
                
                Button(action: {
                    Task {
                        await signUpViewModel.register()
                    }
                }) {
                    Text("Je m'inscris")
                        .foregroundColor(.white)
                        .padding(.vertical)
                        .frame(width: UIScreen.main.bounds.width - 50)
                }
                
                .background(Color("BluePurr"))
                .cornerRadius(10)
                .padding(.top, 25)
            }
            .padding(.horizontal, 25)
            
            if signUpViewModel.alert {
                AuthenticationErrorView(alert: $signUpViewModel.alert, error: $signUpViewModel.error)
            }
        }
        .onTapGesture {
            hideKeyboard()
        }
    }
}
