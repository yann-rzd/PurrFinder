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
            NavigationView {
                VStack {
                    Text("")
                }
                .navigationBarItems(leading: Button(action: {
                    self.show.toggle()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.title)
                        .foregroundColor(Color("Color"))
                })
            }
            .navigationBarBackButtonHidden(true)
            
            VStack {
                Image("Dailympact_logo")
                
                Text("Log in to your account")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(signUpViewModel.color)
                    .padding(.top, 35)
                
                TextField("Email", text: $signUpViewModel.email)
                    .textInputAutocapitalization(.never)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 4).stroke(signUpViewModel.email != "" ? Color("Color") : signUpViewModel.color, lineWidth: 2))
                    .padding(.top, 25)
                
                HStack(spacing: 15) {
                    VStack {
                        if signUpViewModel.visible {
                            TextField("Password", text: $signUpViewModel.pass)
                                .textInputAutocapitalization(.never)
                        } else {
                            SecureField("Password", text: $signUpViewModel.pass)
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
                .background(RoundedRectangle(cornerRadius: 4).stroke(signUpViewModel.pass != "" ? Color("Color") : signUpViewModel.color, lineWidth: 2))
                .padding(.top, 25)
                
                HStack(spacing: 15) {
                    VStack {
                        if signUpViewModel.revisible {
                            TextField("Re-enter", text: $signUpViewModel.repass)
                                .textInputAutocapitalization(.never)
                        } else {
                            SecureField("Re-enter", text: $signUpViewModel.repass)
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
                .background(RoundedRectangle(cornerRadius: 4).stroke(signUpViewModel.repass != "" ? Color("Color") : signUpViewModel.color, lineWidth: 2))
                .padding(.top, 25)
                
                Button(action: {
                    signUpViewModel.register()
                }) {
                    Text("Register")
                        .foregroundColor(.white)
                        .padding(.vertical)
                        .frame(width: UIScreen.main.bounds.width - 50)
                }
                
                .background(Color("Color"))
                .cornerRadius(10)
                .padding(.top, 25)
            }
            .padding(.horizontal, 25)
            
            if signUpViewModel.alert {
                ErrorView(alert: $signUpViewModel.alert, error: $signUpViewModel.error)
            }
        }
    }
}
