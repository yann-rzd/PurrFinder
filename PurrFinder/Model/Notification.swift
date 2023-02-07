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

  func scheduleNotification(animalLocation: CLLocationCoordinate2D, animalName: String, animalDescription: String) {
    
    let content = UNMutableNotificationContent()
    content.title = "Purr Finder: \(animalName) a été perdu!"
    content.body = "Description : \(animalDescription)"
    content.sound = UNNotificationSound.default
    
    let trigger = UNLocationNotificationTrigger(region: getRegion(from: animalLocation), repeats: false)
    
    let request = UNNotificationRequest(identifier: animalName, content: content, trigger: trigger)
    
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
