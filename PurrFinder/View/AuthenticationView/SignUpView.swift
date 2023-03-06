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
                
                TextField("Téléphone", text: $signUpViewModel.phone)
                    .textInputAutocapitalization(.never)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 4).stroke(signUpViewModel.email != "" ? Color("BluePurr") : signUpViewModel.color, lineWidth: 2))
                    .padding(.top, 25)
                
                TextField("Email", text: $signUpViewModel.email)
                    .textInputAutocapitalization(.never)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 4).stroke(signUpViewModel.email != "" ? Color("BluePurr") : signUpViewModel.color, lineWidth: 2))
                    .padding(.top, 25)
                
                HStack(spacing: 15) {
                    VStack {
                        if signUpViewModel.visible {
                            TextField("Mot de passe", text: $signUpViewModel.pass)
                                .textInputAutocapitalization(.never)
                        } else {
                            SecureField("Mot de passe", text: $signUpViewModel.pass)
                                .textInputAutocapitalization(.never)
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
                        } else {
                            SecureField("Re-entre", text: $signUpViewModel.repass)
                                .textInputAutocapitalization(.never)
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
