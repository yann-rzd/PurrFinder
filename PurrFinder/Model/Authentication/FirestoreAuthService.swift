//
//  FirestoreAuthService.swift
//  PurrFinder
//
//  Created by Yann Rouzaud on 15/02/2023.
//

import Foundation
import FirebaseFirestore

final class FirestoreAuthService {
    static let shared = FirestoreAuthService()
    
    private init() { }
    
    func saveNameAndPhone(email: String, name: String, phone: String) {
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(email)
        let userData: [String: Any] = [
            "name": name,
            "phone": phone
        ]
        
        userRef.setData(userData) { error in
            if let error = error {
                // Une erreur s'est produite pendant l'enregistrement
                print("Erreur d'enregistrement des données : \(error.localizedDescription)")
            } else {
                // Les données ont été enregistrées avec succès
                print("Données enregistrées avec succès")
            }
        }
        
    }
}
