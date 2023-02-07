//
//  AuthenticationServiceError.swift
//  PurrFinder
//
//  Created by Yann Rouzaud on 06/02/2023.
//

import Foundation

enum AuthenticationServiceError: LocalizedError {
    case contentsNotFilledProperly
    case emailIdIsEmpty
    case passwordMismatch
    case resetPassword
    
    var errorDescription: String {
        switch self {
        case .contentsNotFilledProperly:
            return "Please fill all the contents properly"
        case .emailIdIsEmpty:
            return "Email Id is empty"
        case .passwordMismatch:
            return "Password mismacth"
        case .resetPassword:
            return "RESET"
        
        }
    }
}
