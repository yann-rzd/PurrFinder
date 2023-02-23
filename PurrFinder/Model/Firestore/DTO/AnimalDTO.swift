//
//  PostAlertDTO.swift
//  PurrFinder
//
//  Created by Yann Rouzaud on 16/02/2023.
//

import Foundation

struct AnimalDTO: Decodable {
    let animalName: String
    let animalType: String
    let locationLatitude: Double
    let locationLongitude: Double
    let date: Date
    let userId: String
}
