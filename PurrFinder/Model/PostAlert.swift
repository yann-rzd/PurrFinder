//
//  PostAlert.swift
//  PurrFinder
//
//  Created by Yann Rouzaud on 07/02/2023.
//

import Foundation
import FirebaseFirestore
import CoreLocation

struct Post {
    var id: String
    var userID: String
    var animalName: String
    var animalDescription: String
    var animalImageURL: String
    var location: CLLocationCoordinate2D
    var timestamp: Timestamp
    
    init(id: String, userID: String, animalName: String, animalDescription: String, animalImageURL: String, location: CLLocationCoordinate2D, timestamp: Timestamp) {
        self.id = id
        self.userID = userID
        self.animalName = animalName
        self.animalDescription = animalDescription
        self.animalImageURL = animalImageURL
        self.location = location
        self.timestamp = timestamp
    }
    
    init?(document: QueryDocumentSnapshot) {
        let data = document.data()
        
        guard let userID = data["userID"] as? String,
              let animalName = data["animalName"] as? String,
              let animalDescription = data["animalDescription"] as? String,
              let animalImageURL = data["animalImageURL"] as? String,
              let location = data["location"] as? [String: Double],
              let latitude = location["latitude"],
              let longitude = location["longitude"],
              let timestamp = data["timestamp"] as? Timestamp else {
            return nil
        }
        
        self.id = document.documentID
        self.userID = userID
        self.animalName = animalName
        self.animalDescription = animalDescription
        self.animalImageURL = animalImageURL
        self.location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        self.timestamp = timestamp
    }
}

// comparer les instances de Post pour le tri
extension Post: Comparable {
    static func == (lhs: Post, rhs: Post) -> Bool {
        return lhs.id == rhs.id
    }
    
    static func < (lhs: Post, rhs: Post) -> Bool {
        return lhs.timestamp.compare(rhs.timestamp) == .orderedAscending
    }
}
