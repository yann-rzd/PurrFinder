//
//  OpenAIAPICaller.swift
//  PurrFinder
//
//  Created by Yann Rouzaud on 26/02/2023.
//

import Foundation
import OpenAISwift

final class OpenAIAPICaller {
    
    // MARK: - PATTERN: singleton
    
    static let shared = OpenAIAPICaller()
    
    init() {}
    
    
    // MARK: - INTERNAL: methods
    
    func setup() {
        self.client = OpenAISwift(authToken: APIKeys.OpenAiKey)
    }
    
    
    /// The function uses a client instance to send a completion request with the input provided to the OpenAI GPT-3 API.
    /// - parameter input: String the prompt.
    func getResponse(input: String,
                            completion: @escaping (Result<String, Error>) -> Void) {
        client?.sendCompletion(with: input, model: .gpt3(.davinci), maxTokens: 1000, completionHandler: { result in
            switch result {
            case .success(let model):
                guard let output = model.choices.first?.text else {
                    return
                }
                completion(.success(output))
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
    
    
    // MARK: - PRIVATE: properties
    
     var client: OpenAISwift?
}
