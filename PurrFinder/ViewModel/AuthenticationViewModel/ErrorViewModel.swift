//
//  ErrorViewModel.swift
//  PurrFinder
//
//  Created by Yann Rouzaud on 06/02/2023.
//

import Foundation
import MapKit
import SwiftUI

extension ErrorView {
    @MainActor class ErrorViewModel: ObservableObject {
        @Published var color = Color.black.opacity(0.7)
    }
}
