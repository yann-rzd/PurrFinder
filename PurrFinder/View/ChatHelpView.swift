//
//  ChatHelpView.swift
//  PurrFinder
//
//  Created by Yann Rouzaud on 07/02/2023.
//

import SwiftUI
import Combine

struct ChatHelpView: View {
    @StateObject var viewModel = ChatHelpViewModel()
    
    var body: some View {
        VStack {
            Text("Posez vos questions")
                .font(Font.custom("AmaticSC-Bold", size: 32))
                .foregroundColor(Color("BluePurr"))
                .padding(.top, 20)
            
            ScrollView {
                LazyVStack {
                    ForEach(viewModel.chatMessages, id: \.id) { message in
                            viewModel.messageView(message: message)
                    }
                }
            }
            
            HStack {
                TextField("Entrer un message", text: $viewModel.messagetext) {
                    
                }
                    .padding()
                    .background(.gray.opacity(0.1))
                    .cornerRadius(12)
                Button {
                    viewModel.sendMessage()
                } label: {
                    Text("Envoyer")
                        .foregroundColor(.white)
                        .padding()
                        .background(.black)
                        .cornerRadius(12)
                }

            }
        }
        .padding()
    }
}

struct ChatHelpView_Previews: PreviewProvider {
    static var previews: some View {
        ChatHelpView()
    }
}



