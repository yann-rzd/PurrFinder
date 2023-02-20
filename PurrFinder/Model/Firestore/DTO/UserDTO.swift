//
//  UserDTO.swift
//  PurrFinder
//
//  Created by Yann Rouzaud on 16/02/2023.
//

import Foundation

struct UserDTO: Decodable {
    let uid: String
    let name: String
    let email: String
    let phone: String
    let profileImageData: Data?
    let locationLatitude: String?
    let locationLongitude: String?
}
