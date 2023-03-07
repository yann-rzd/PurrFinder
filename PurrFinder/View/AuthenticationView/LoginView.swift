//
//  LoginView.swift
//  PurrFinder
//
//  Created by Yann Rouzaud on 06/02/2023.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var loginViewModel = LoginViewModel()
    @State var show: Bool = false
    
    
    var body: some View {
        NavigationView {
            ZStack {
                
                VStack {
                    Image("Logo")
                        .resizable()
                        .frame(width: 150, height: 150)
                    
                    Text("PurrFinder")
                        .font(Font.custom("AmaticSC-Bold", size: 32))
                        .foregroundColor(Color("BluePurr"))
                    
                    
                    Text("Se connecter")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(loginViewModel.color)
                        .padding(.top, 35)
                    
                    TextField("Email", text: $loginViewModel.email)
                        .textInputAutocapitalization(.never)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 4).stroke(loginViewModel.email != "" ? Color("BluePurr") : loginViewModel.color, lineWidth: 2))
                        .padding(.top, 25)
                        .keyboardType(.emailAddress)
                        .submitLabel(.done)
                    
                    HStack(spacing: 15) {
                        VStack {
                            if loginViewModel.visible {
                                TextField("Mot de passe", text: $loginViewModel.pass)
                                    .textInputAutocapitalization(.never)
                                    .submitLabel(.done)
                            } else {
                                SecureField("Mot de passe", text: $loginViewModel.pass)
                                    .textInputAutocapitalization(.never)
                                    .submitLabel(.done)
                            }
                        }
                        
                        Button(action: {
                            loginViewModel.visible.toggle()
                        }) {
                            Image(systemName: loginViewModel.visible ? "eye.slash.fill" : "eye.fill")
                                .foregroundColor(loginViewModel.color)
                        }
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 4).stroke(loginViewModel.pass != "" ? Color("BluePurr") : loginViewModel.color, lineWidth: 2))
                    .padding(.top, 25)
                    
                    HStack {
                        Spacer()
                        
                        Button(action: {
                            Task {
                                await loginViewModel.reset()
                            }
                        }) {
                            Text("Mot de passe oublié")
                                .fontWeight(.bold)
                                .foregroundColor(Color("BluePurr"))
                        }
                    }
                    .padding(.top, 20)
                    
                    Button(action: {
                        Task {
                            await loginViewModel.verify()
                        }
                    }) {
                        Text("Je me connecte")
                            .foregroundColor(.white)
                            .padding(.vertical)
                            .frame(width: UIScreen.main.bounds.width - 50)
                    }
                    .background(Color("BluePurr"))
                    .cornerRadius(10)
                    .padding(.top, 25)
                }
                .padding(.horizontal, 25)
                
                NavigationLink(
                    destination: SignUpView(show: $show),
                    isActive: $show
                ) {
                    EmptyView()
                }
                .hidden()
            }
            .navigationBarItems(trailing: Button(action: {
                self.show.toggle()
            }) {
                Text("S'inscrire")
                    .fontWeight(.bold)
                    .foregroundColor(Color("BluePurr"))
            })
            
            
            if loginViewModel.alert {
                AuthenticationErrorView(alert: $loginViewModel.alert, error: $loginViewModel.error)
            }
        }
        .onTapGesture {
            hideKeyboard()
        }
        
    }
}
