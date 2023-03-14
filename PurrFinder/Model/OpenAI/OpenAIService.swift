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
    
    // MARK: - INTERNAL: properties
    let basUrl = "https://api.openai.com/v1/"
    
    
    // MARK: - INTERNAL: methods
    
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


