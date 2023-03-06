//
//  ChatMessage.swift
//  PurrFinder
//
//  Created by Yann Rouzaud on 06/03/2023.
//

import Foundation

struct OpenAICompletionBody: Encodable {
    let model: String
    let prompt: String
    let temperature: Float?
    let max_tokens: Int
}
