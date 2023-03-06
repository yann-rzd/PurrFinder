//
//  OpenAIService.swift
//  PurrFinder
//
//  Created by Yann Rouzaud on 26/02/2023.
//

import Foundation
import Alamofire
import Combine

class OpenAIService {
    let basUrl = "https://api.openai.com/v1/"
    
    func sendMessage(message: String) -> AnyPublisher<OpenAICompletionsResponse, Error> {
        let body = OpenAICompletionBody(model: "text-davinci-003", prompt: message, temperature: 0.7, max_tokens: 500)
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(APIKeys.openAIAPIKey)"
        ]
        
        return Future { [weak self] promise in
            guard let self = self else { return }
            
            AF.request(self.basUrl + "completions", method: .post, parameters: body, encoder: .json, headers: headers).responseDecodable(of: OpenAICompletionsResponse.self) { response in
                switch response.result {
                case .success(let result):
                    promise(.success(result))
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}

struct OpenAICompletionBody: Encodable {
    let model: String
    let prompt: String
    let temperature: Float?
    let max_tokens: Int
}

struct OpenAICompletionsResponse: Decodable {
    let id: String
    let choices: [OpenAICompletionChoice]
}

struct OpenAICompletionChoice: Decodable {
    let text: String
}
