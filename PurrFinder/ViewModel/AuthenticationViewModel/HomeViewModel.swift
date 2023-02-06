//
//  HomeViewModel.swift
//  PurrFinder
//
//  Created by Yann Rouzaud on 06/02/2023.
//

import Foundation
import MapKit

extension HomeView {
    @MainActor class HomeViewModel: ObservableObject {
        @Published var show = false
        @Published var status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
    }
}
