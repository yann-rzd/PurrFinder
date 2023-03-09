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
#if EMULATORS
        print(
        """
        ****************************************************
        Testing on Emulators
        ****************************************************
        """
        )
        Auth.auth().useEmulator(withHost:"localhost", port:9099)
        Storage.storage().useEmulator(withHost: "localhorst", port: 9199)
        let settings = Firestore.firestore().settings
        settings.host = "localhost:8080"
        settings.isPersistenceEnabled = false
        settings.isSSLEnabled = false
        Firestore.firestore().settings = settings
#elseif DEBUG
        print(
        """
        ****************************************************
        Testing on Live Server
        ****************************************************
        """
        )
#endif
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
