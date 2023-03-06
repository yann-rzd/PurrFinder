//
//  ChatHelpViewModel.swift
//  PurrFinder
//
//  Created by Yann Rouzaud on 06/03/2023.
//

import SwiftUI
import Foundation
import Combine

extension ChatHelpView {
    @MainActor class ChatHelpViewModel: ObservableObject {
        @Published var chatMessages: [ChatMessage] = []
        @Published var messagetext: String = ""
        
        let openAIService = OpenAIService()
        @Published var cancellables = Set<AnyCancellable>()
        
        func messageView(message: ChatMessage) -> some View {
            HStack {
                if message.sender == .user { Spacer() }
                Text(message.content)
                    .foregroundColor(message.sender == .user ? .white : .black)
                    .padding()
                    .background(message.sender == .user ? .blue : .gray.opacity(0.1))
                    .cornerRadius(16)
                if message.sender == .gpt { Spacer() }
            }
            
        }
        
        func sendMessage() {
            let userMessage = ChatMessage(id: UUID().uuidString, content: messagetext, dateCreated: Date(), sender: .user)
            chatMessages.append(userMessage)
            
            openAIService.sendMessage(message: messagetext).sink { completion in
                // Handle error
            } receiveValue: { response in
                guard let textResponse = response.choices.first?.text.trimmingCharacters(in: .whitespacesAndNewlines.union(.init(charactersIn: "\""))) else { return }
                let gptMessage = ChatMessage(id: response.id, content: textResponse, dateCreated: Date(), sender: .gpt)
                self.chatMessages.append(gptMessage)
            }
            .store(in: &cancellables)

            messagetext = ""
        }
    }
}
