//
//  OpenAIAPICaller.swift
//  PurrFinder
//
//  Created by Yann Rouzaud on 26/02/2023.
//

import Foundation
import OpenAISwift

final class OpenAIAPICaller {
    static let shared = OpenAIAPICaller()
    
    @frozen enum Constants {
        static let key = "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"
    }
    
    private var client: OpenAISwift?
    
    private init() {}
    
    public func setup() {
        self.client = OpenAISwift(authToken: Constants.key)
    }
    
    public func getResponse(input: String,
                            completion: @escaping (Result<String, Error>) -> Void) {
        client?.sendCompletion(with: input, model: .gpt3(.davinci), maxTokens: 1000, completionHandler: { result in
            switch result {
            case .success(let model):
                print(String(describing: model.choices.first?.text))
                let output = model.choices.first?.text ?? ""
                completion(.success(output))
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
}
