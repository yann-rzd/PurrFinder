//
//  PurrFinderApp.swift
//  PurrFinder
//
//  Created by Yann Rouzaud on 06/02/2023.
//

import SwiftUI
import Firebase
import FirebaseCore
import FirebaseAuth
import FirebaseStorage
import FirebasePerformance

@main
struct PurrFinderApp: App {
    
    init() {
        FirebaseApp.configure()
        if ProcessInfo.processInfo.environment["unit_tests"] == "true" {
          print("Setting up Firebase emulator localhost:8080")
          let settings = Firestore.firestore().settings
          settings.host = "localhost:8080"
          settings.isPersistenceEnabled = false
          settings.isSSLEnabled = false
          Firestore.firestore().settings = settings
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
