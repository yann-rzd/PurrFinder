//
//  UserData.swift
//  PurrFinder
//
//  Created by Yann Rouzaud on 06/02/2023.
//

import Foundation
import Firebase
import SwiftUI

struct User {
    var uid: String
    var name: String
    var email: String
    var phone: String
    var profileImage: UIImage?
    var locationLatitude: String?
    var locationLongitude: String?
}


