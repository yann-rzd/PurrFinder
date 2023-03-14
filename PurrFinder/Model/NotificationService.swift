//
//  NotificationData.swift
//  PurrFinder
//
//  Created by Yann Rouzaud on 06/02/2023.
//

import Foundation
import SwiftUI
import UserNotifications
import CoreLocation

final class NotificationService {
    
    static let shared = NotificationService()
    
    
    
    // MARK: - INTERNAL: methods
    
    func requestNotificationAuthorization() {
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings(completionHandler: { settings in
            if settings.authorizationStatus != .authorized {
                center.requestAuthorization(options: [.alert, .sound, .badge]) {
                   granted, error in

                   if let error = error {
                        print("error : \(error)")
                   }
                }
            }
        })
    }

    func checkForPermission(ownerLocation: CLLocationCoordinate2D,
                            animalImage: UIImage,
                            animalName: String,
                            animalType: String,
                            animalBreed: String,
                            animalDescription: String,
                            ownerName: String,
                            ownerPhone: String) {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .authorized:
                self.scheduleNotification(ownerLocation: ownerLocation,
                                          animalImage: animalImage,
                                          animalName: animalName,
                                          animalType: animalType,
                                          animalBreed: animalBreed,
                                          animalDescription: animalDescription,
                                          ownerName: ownerName,
                                          ownerPhone: ownerPhone)
            case .denied:
                return
            case .notDetermined:
                notificationCenter.requestAuthorization(options: [.alert, .sound]) { didAlllow, error in
                    if didAlllow {
                        self.scheduleNotification(ownerLocation: ownerLocation,
                                                  animalImage: animalImage,
                                                  animalName: animalName,
                                                  animalType: animalType,
                                                  animalBreed: animalBreed,
                                                  animalDescription: animalDescription,
                                                  ownerName: ownerName,
                                                  ownerPhone: ownerPhone)
                    }
                }
            default:
                return
            }
        }
    }
    
    func getRegion(from location: CLLocationCoordinate2D) -> CLCircularRegion {
        let region = CLCircularRegion(center: location, radius: 10, identifier: "PetLocation")
        region.notifyOnEntry = true
        region.notifyOnExit = false

        print("🌍🌍🌍🌍🌍🌍🌍 REGION 🌍🌍🌍🌍🌍🌍🌍 : \(region)")

        return region
    }

    
    // MARK: - PRIVATE: properties
    
    private init() { }
    private let notificationCenter = UNUserNotificationCenter.current()

    
    // MARK: - PRIVATE: methods
    
    private func scheduleNotification(ownerLocation: CLLocationCoordinate2D, animalImage: UIImage, animalName: String, animalType: String, animalBreed: String, animalDescription: String, ownerName: String, ownerPhone: String) {
        
        let identifier = "Un animale s'est égaré dans votre zone"
        
        let content = UNMutableNotificationContent()
        content.title = "Purr Finder: \(animalName) a été perdu!"
        content.body = "\(animalImage)\n\(animalType)\nDescription : \(animalDescription)\nPropriétaire : \(ownerName)\n\(ownerPhone)"
        content.sound = UNNotificationSound.default
        
        let trigger = UNLocationNotificationTrigger(region: getRegion(from: ownerLocation), repeats: false)
        
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        print("📬📬📬📬📬 REQUEST NOTIFICATION 📬📬📬📬📬 : \(request)")
        
        notificationCenter.add(request) { (error) in
            if let error = error {
                print("Error scheduling notification: \(error)")
            }
        }
    }
}
