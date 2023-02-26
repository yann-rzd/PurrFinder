//
//  PurrFinderApp.swift
//  PurrFinder
//
//  Created by Yann Rouzaud on 06/02/2023.
//

import SwiftUI
import Firebase

@main
struct PurrFinderApp: App {
    
    init() {
        FirebaseApp.configure()
        OpenAIAPICaller.shared.setup()
      }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
