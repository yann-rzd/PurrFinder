//
//  ImagePickerViewController.swift
//  PurrFinder
//
//  Created by Yann Rouzaud on 08/02/2023.
//

import SwiftUI
import Photos

class ImagePickerViewModel: ObservableObject {
    @Published var profileImage: UIImage?
    @Published var showPicker = false
    @Published var presentNotAuthorizedProhibitedAlert = false
    @Published private var authorizationStatus = PHPhotoLibrary.authorizationStatus()
    @Published var changeProfileImage = false
    
//    func showPhotoPicker() {
//        showPicker = true
//    }
    
    func checkAuthorization() {
        authorizationStatus = PHPhotoLibrary.authorizationStatus()
        switch authorizationStatus {
        case .notDetermined, .restricted, .denied:
            requestAccess()
        case .authorized, .limited:
            changeProfileImage = true
        default:
            break
        }
    }
    
    func requestAccess() {
        PHPhotoLibrary.requestAuthorization { (status) in
            DispatchQueue.main.async {
                self.authorizationStatus = status
                switch status {
                case .authorized:
                    self.changeProfileImage = true
                default:
                    self.authorizationStatus = status
                    self .presentNotAuthorizedProhibitedAlert = true
                }
            }
        }
    }
}
