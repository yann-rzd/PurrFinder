//
//  ChatMessage.swift
//  PurrFinder
//
//  Created by Yann Rouzaud on 06/03/2023.
//

import Foundation

struct ChatMessage {
    let id: String
    let content: String
    let dateCreated: Date
    let sender: MessageSender
}
