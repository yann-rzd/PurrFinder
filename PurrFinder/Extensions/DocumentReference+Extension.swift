//
//  DocumentReference+Extension.swift
//  PurrFinder
//
//  Created by Yann Rouzaud on 16/02/2023.
//

import Foundation
import FirebaseFirestore

extension DocumentReference {
    
    func getDocument<T: Decodable>(as type: T.Type) async throws -> T {
        do {
            let document = try await self.getDocument().data()
            if let documentData = document {
                let jsonData = try JSONSerialization.data(withJSONObject: documentData)
                let decoder = JSONDecoder()
                let decodedData = try decoder.decode(T.self, from: jsonData)
                return decodedData
            } else {
                throw FirestoreServiceError.documentNotFound
            }
        } catch {
            throw FirestoreServiceError.decodeError
        }
    }
    
    
    func setData<T>(myStruct: T) async throws {
        var dataContainer: [String: Any] = [:]

        let mirror = Mirror(reflecting: myStruct)

        for case let (key?, value) in mirror.children {
            dataContainer[key] = value
        }
        
        try await self.setData(dataContainer)
    }
}
