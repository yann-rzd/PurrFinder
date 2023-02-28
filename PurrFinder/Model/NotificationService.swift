//
//  NotificationData.swift
//  PurrFinder
//
//  Created by Yann Rouzaud on 06/02/2023.
//

import Foundation
import UserNotifications
import CoreLocation

final class NotificationService {
    
    // MARK: - PATTERN: singleton
    
    static let shared = NotificationService()
    
    private init() { }
    
    
    // MARK: - INTERNAL: methods
    
    func requestNotificationAuthorization() {
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings(completionHandler: { settings in
            if settings.authorizationStatus != .authorized {
                // request for notification permissions for alert, sound and badge
                center.requestAuthorization(options: [.alert, .sound, .badge]) {
                   granted, error in

                   if let error = error {
                        // handle the error here
                        print("error : \(error)")
                   }
                }
            }
        })
    }
    
    func checkForPermission(ownerLocation: CLLocationCoordinate2D, animalName: String, animalType: String) {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .authorized:
                self.scheduleNotification(ownerLocation: ownerLocation, animalName: animalName, animalType: animalType)
            case .denied:
                return
            case .notDetermined:
                notificationCenter.requestAuthorization(options: [.alert, .sound]) { didAlllow, error in
                    if didAlllow {
                        self.scheduleNotification(ownerLocation: ownerLocation, animalName: animalName, animalType: animalType)
                    }
                }
            default:
                return
            }
        }
    }
    
    
    // MARK: - PRIVATE: properties
    
    private let notificationCenter = UNUserNotificationCenter.current()
    
    
    // MARK: - PRIVATE: methods
    
    private func scheduleNotification(ownerLocation: CLLocationCoordinate2D, animalName: String, animalType: String) {
        
        let identifier = "Un animale s'est égaré dans votre zone"
        
        let content = UNMutableNotificationContent()
        content.title = "Purr Finder: \(animalName) a été perdu!"
        content.body = "Description : \(animalType)"
        content.sound = UNNotificationSound.default
        
        let trigger = UNLocationNotificationTrigger(region: getRegion(from: ownerLocation), repeats: false)
        
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        print("REQUEST NOTIFICATION : \(request)")
        
        notificationCenter.add(request) { (error) in
            if let error = error {
                print("Error scheduling notification: \(error)")
            }
        }
    }
    
    private func getRegion(from location: CLLocationCoordinate2D) -> CLCircularRegion {
        let region = CLCircularRegion(center: location, radius: 1000, identifier: "PetLocation")
        region.notifyOnEntry = true
        region.notifyOnExit = false
        print("REGION : \(region)")
        
        return region
    }
}
