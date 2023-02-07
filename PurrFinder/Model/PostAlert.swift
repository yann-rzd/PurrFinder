//
//  PostAlert.swift
//  PurrFinder
//
//  Created by Yann Rouzaud on 07/02/2023.
//

import Foundation
import FirebaseFirestore
import CoreLocation

struct PostAlert {
    var animal: Animal
    var description: String
    var location: CLLocationCoordinate2D
    var date: Date
    var user: User
    
    init(animal: Animal, description: String, location: CLLocationCoordinate2D, date: Date, user: User) {
        self.animal = animal
        self.description = description
        self.location = location
        self.date = date
        self.user = user
    }
}
