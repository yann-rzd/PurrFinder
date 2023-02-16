//
//  FirestoreError.swift
//  PurrFinder
//
//  Created by Yann Rouzaud on 16/02/2023.
//

import Foundation

enum FirestoreServiceError: Error {
    case documentNotFound
    case decodeError
    case failedToFetchUserData
}
