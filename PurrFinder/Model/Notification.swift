//
//  NotificationData.swift
//  PurrFinder
//
//  Created by Yann Rouzaud on 06/02/2023.
//

import Foundation
import UserNotifications
import CoreLocation

final class Notification {
    
    static let shared = Notification()
    
    private init() { }
    
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
    
    func checkForPermission(animalLocation: CLLocationCoordinate2D, animalName: String, animalType: String) {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .authorized:
                self.scheduleNotification(animalLocation: animalLocation, animalName: animalName, animalType: animalType)
            case .denied:
                return
            case .notDetermined:
                notificationCenter.requestAuthorization(options: [.alert, .sound]) { didAlllow, error in
                    if didAlllow {
                        self.scheduleNotification(animalLocation: animalLocation, animalName: animalName, animalType: animalType)
                    }
                }
            default:
                return
            }
        }
    }
    
    private func scheduleNotification(animalLocation: CLLocationCoordinate2D, animalName: String, animalType: String) {
        
        let identifier = "Un animale s'est égaré dans votre zone"
        
        let content = UNMutableNotificationContent()
        content.title = "Purr Finder: \(animalName) a été perdu!"
        content.body = "Description : \(animalType)"
        content.sound = UNNotificationSound.default
        
        let trigger = UNLocationNotificationTrigger(region: getRegion(from: animalLocation), repeats: false)
        
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
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
        return region
    }
    
    private let notificationCenter = UNUserNotificationCenter.current()
}
