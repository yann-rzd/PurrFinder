//
//  Animal+Extention.swift
//  PurrFinder
//
//  Created by Yann Rouzaud on 23/02/2023.
//

import Foundation

extension PostAlert {
    func createPostAlertData() -> PostAlertDTO {
        .init(
            uid: uid,
            animalName: animalName,
            animalType: animalType,
            animalBreed: animalBreed,
            animalDescription: animalDescription,
            postDate: postDate,
            ownerUid: ownerUid

        )
    }
}
