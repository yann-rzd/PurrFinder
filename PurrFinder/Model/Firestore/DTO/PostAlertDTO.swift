//
//  PostAlertDTO.swift
//  PurrFinder
//
//  Created by Yann Rouzaud on 16/02/2023.
//

import Foundation

struct PostAlertDTO: Decodable {
    let uid: String
    let animalName: String
    let animalType: String
    let animalBreed: String
    let animalDescription: String
    let postDate: Date
    let ownerUid: String
}
