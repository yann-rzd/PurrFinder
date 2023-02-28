//
//  View+Extension.swift
//  PurrFinder
//
//  Created by Yann Rouzaud on 28/02/2023.
//

import Foundation
import SwiftUI

extension View {
    func hideKeyboard() {
        let resign = #selector(UIResponder.resignFirstResponder)
        UIApplication.shared.sendAction(resign, to: nil, from: nil, for: nil)
    }
}
