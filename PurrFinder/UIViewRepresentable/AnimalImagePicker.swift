//
//  AnimalImagePicker.swift
//  PurrFinder
//
//  Created by Yann Rouzaud on 24/02/2023.
//

import SwiftUI

struct AnimalImagePicker: UIViewControllerRepresentable {
    
    @Binding var image: UIImage?
    
    private let controller = UIImagePickerController()
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self, storageService: StorageService.shared)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
        let parent: AnimalImagePicker
        let storageService: StorageService
        
        init(parent: AnimalImagePicker, storageService: StorageService) {
            self.parent = parent
            self.storageService = storageService
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            parent.image = info[.originalImage] as? UIImage
            if let image = parent.image {
                storageService.persistAnimalImageToStorage(image: image)
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