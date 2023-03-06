//
//  OpenAICompletionsResponse.swift
//  PurrFinder
//
//  Created by Yann Rouzaud on 06/03/2023.
//

import Foundation

struct OpenAICompletionsResponse: Decodable {
    let id: String
    let choices: [OpenAICompletionChoice]
}

struct OpenAICompletionChoice: Decodable {
    let text: String
}
