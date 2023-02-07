//
//  LostPetData.swift
//  PurrFinder
//
//  Created by Yann Rouzaud on 06/02/2023.
//

import Foundation
import CoreLocation

struct LostPetData {
    let name: String
        let species: String
        let breed: String
        let color: String
        let age: Int
        let size: String
        let location: CLLocation
        let imageUrl: String
        let description: String
        let ownerId: String
        let postDate: Date
}
