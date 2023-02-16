//
//  PostAlertDTO.swift
//  PurrFinder
//
//  Created by Yann Rouzaud on 16/02/2023.
//

import Foundation

struct PostAlertDTO: Encodable {
    let animalName: String
    let animalType: String
    let locationLatitude: Double
    let locationLongitude: Double
    let date: Date
    let userId: UUID
    
    
    init(postAlert: PostAlert) {
        self.animalName = postAlert.animal.name
        self.animalType = postAlert.animal.type
        self.locationLatitude = postAlert.location.latitude
        self.locationLongitude = postAlert.location.longitude
        self.date = postAlert.date
        self.userId = postAlert.user.id
        
    }
}
