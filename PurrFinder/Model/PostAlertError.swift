//
//  PostAlertError.swift
//  PurrFinder
//
//  Created by Yann Rouzaud on 23/02/2023.
//

import Foundation

enum PostAlertError: LocalizedError {
    case petNameIsEmpty
    case petTypeIsEmpty
    case petBreedIsEmpty
    case petDescriptionIsEmpty
    
    var errorDescription: String {
        switch self {
            
        case .petNameIsEmpty:
            return "Veuillez renseigner le nom de votre animale"
        case .petTypeIsEmpty:
            return "Veuillez renseigner le type d'animale"
        case .petBreedIsEmpty:
            return "Veuillez renseigner la race de l'animale"
        case .petDescriptionIsEmpty:
            return "Veuillez renseigner une description"
        }
    }
}
