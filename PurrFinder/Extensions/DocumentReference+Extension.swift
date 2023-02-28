//
//  DocumentReference+Extension.swift
//  PurrFinder
//
//  Created by Yann Rouzaud on 16/02/2023.
//

import Foundation
import FirebaseFirestore

extension DocumentReference {
    
    
    /// This function retrieves a document from Firebase Firestore, then decodes it using the generic T type compliant with the Decodable protocol.
    /// - parameter Type: generic T type compliant with the Decodable.
    /// - throws: FirestoreServiceError.documentNotFound if the document data is null.
    /// - throws : FirestoreServiceError.decodeError if decoding fails or an error
    /// - returns: Tuple containing the document ID and the decoded data if the decoding succeeds
    func getDocument<T: Decodable>(as type: T.Type) async throws -> (String, T) {
        do {
            let document = try await self.getDocument()
           
            let documentData = document.data()
            
            if let documentData = documentData {
                let jsonData = try JSONSerialization.data(withJSONObject: documentData)
                let decoder = JSONDecoder()
                let decodedData = try decoder.decode(T.self, from: jsonData)
                return (document.documentID, decodedData)
            } else {
                throw FirestoreServiceError.documentNotFound
            }
        } catch {
            throw FirestoreServiceError.decodeError
        }
    }
    
    
    /// This function converts the properties of the structure into a [String: Any] dictionary and returns them to an asynchronous setData function.
    /// - parameter myStruct: generic T.
    func setData<T>(myStruct: T) async throws {
        var dataContainer: [String: Any] = [:]

        // Mirror allows to inspect the values of mysStruct, including its properties.
        let mirror = Mirror(reflecting: myStruct)

        // Extracting the keys and values of each child
        for case let (key?, value) in mirror.children {
            dataContainer[key] = value
        }
        
        try await self.setData(dataContainer)
    }
}
