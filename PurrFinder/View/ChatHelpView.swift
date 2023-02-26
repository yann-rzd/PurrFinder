//
//  ChatHelpView.swift
//  PurrFinder
//
//  Created by Yann Rouzaud on 07/02/2023.
//

import SwiftUI

struct ChatHelpView: View {
    @State private var models = [String]()
    @State private var text = ""
    
    var body: some View {
        NavigationView {
            VStack {
                
                
                List(models, id: \.self) { model in
                    Text(model)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                }
                TextField("Type here...", text: $text)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.black, lineWidth: 1)
                    )
                    .padding(.horizontal)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.bottom, 10)
                    .onSubmit(addModel)
            }
        }
        
    }
    
    func addModel() {
        if !text.isEmpty {
            models.append(text)
            OpenAIAPICaller.shared.getResponse(input: text) { result in
                switch result {
                case .success(let output):
                    self.models.append(output)
                    print("MODELS : \(models)")
                    DispatchQueue.main.async {
                        self.text = ""
                    }
                case .failure:
                    print("Failed")
                }
            }
        }
    }
}

struct ChatHelpView_Previews: PreviewProvider {
    static var previews: some View {
        ChatHelpView()
    }
}
