//
//  AuthenticationServiceError.swift
//  PurrFinder
//
//  Created by Yann Rouzaud on 06/02/2023.
//

import Foundation

enum FirebaseAuthServiceError: LocalizedError {
    case contentsNotFilledProperly
    case emailIdIsEmpty
    case passwordMismatch
    case resetPassword
    case phoneNumberFormatIsIncorrect
    case emailFormatIsInccorect
    case currentUserNotFound
    
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
        case .phoneNumberFormatIsIncorrect:
            return "Phone number format incorrect"
        case .emailFormatIsInccorect:
            return "Email address format incorrect"
        case .currentUserNotFound:
            return "Current user not found"
        
        }
    }
}
