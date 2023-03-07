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
    
    
    /// This function asks the user for permission to send notifications to the application via the user's notification center.
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

    /// This function checks if the application has permission to send notifications and schedules the notification if permission is granted.
    /// - parameter CLLocationCoordinate2D: location of the animal owner.
    /// - parameter animalName: String, name of the animal.
    /// - parameter animalType: String type of the animal
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
    
    /// This function allows you to schedule a local notification based on the user's geographical location.
    /// - parameter CLLocationCoordinate2D: location of the animal owner.
    /// - parameter animalName: String, name of the animal.
    /// - parameter animalType: String type of the animal
    private func scheduleNotification(ownerLocation: CLLocationCoordinate2D, animalName: String, animalType: String) {
        
        let identifier = "Un animale s'est égaré dans votre zone"
        
        let content = UNMutableNotificationContent()
        content.title = "Purr Finder: \(animalName) a été perdu!"
        content.body = "Description : \(animalType)"
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
    
    
    /// This function allows to create a circular geographic region from a given geographic position
    /// - parameter location: geographical position.
    /// - returns: a circular geographic region
    private func getRegion(from location: CLLocationCoordinate2D) -> CLCircularRegion {
        let region = CLCircularRegion(center: location, radius: 1000, identifier: "PetLocation")
        region.notifyOnEntry = true
        region.notifyOnExit = false

        print("REGION : \(region)")
        
        return region
    }
}
