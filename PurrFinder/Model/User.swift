//
//  UserData.swift
//  PurrFinder
//
//  Created by Yann Rouzaud on 06/02/2023.
//

import Foundation
import CoreLocation
import UIKit

struct User: Identifiable {
    let id = UUID()
    let name: String
    let email: String
    let phone: String
    let profileImage: UIImage?
    let location: CLLocation?
}
