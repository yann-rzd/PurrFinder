//
//  User+Extention.swift
//  PurrFinder
//
//  Created by Yann Rouzaud on 16/02/2023.
//

import Foundation

extension User {
    func createUserData() -> UserDTO {
        .init(
            uid: uid,
            name: name,
            email: email,
            phone: phone,
            profileImage: profileImage?.pngData(),
            locationLatitude: locationLatitude,
            locationLongitude: locationLongitude
        )
    }
}
