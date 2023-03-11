//
//  ImagePicker.swift
//  PurrFinder
//
//  Created by Yann Rouzaud on 20/02/2023.
//

import SwiftUI

struct ProfileImagePicker: UIViewControllerRepresentable {
    
    @Binding var image: UIImage?
    private let controller = UIImagePickerController()
    private let firebaseAuthService = FirebaseAuthService.shared
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self, storageService: StorageService.shared, firebaseAuthService: firebaseAuthService)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
        let parent: ProfileImagePicker
        let storageService: StorageService
        let firebaseAuthService: FirebaseAuthService
        
        
        init(parent: ProfileImagePicker, storageService: StorageService, firebaseAuthService: FirebaseAuthService) {
            self.parent = parent
            self.storageService = storageService
            self.firebaseAuthService = firebaseAuthService
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
            parent.image = info[.originalImage] as? UIImage
            if let image = parent.image {
                let userUID = firebaseAuthService.getCurrentUserUID()
                storageService.persistProfileImageToStorage(userUID: userUID, image: image)
            }
            picker.dismiss(animated: true)
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
        
        
    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        controller.delegate = context.coordinator
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }

    
}
