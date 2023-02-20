//
//  StorageService.swift
//  PurrFinder
//
//  Created by Yann Rouzaud on 20/02/2023.
//

import Foundation
import FirebaseStorage

final class StorageService {
    
    static let shared = StorageService()
    
    private init() {}
    
    private let firebaseAuthService = FirebaseAuthService.shared
    
    func persistImageToStorage(image: UIImage) {
        let userUID = firebaseAuthService.getCurrentUserUID()
        let ref = Storage.storage().reference(withPath: "profileImages/\(userUID)")
        
        guard let imageData = image.jpegData(compressionQuality: 0.5) else { return }
        
        ref.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                print("Failed to push image to Storage : \(error)")
                return
            }
            
            ref.downloadURL { url, error in
                if let error = error {
                    print("Failed to retreive downLoadURL : \(error)")
                    return
                }
                print("Successfully stored image with url : \(url?.absoluteString ?? "")")
            }
            
        }
    }
    
    
    func downloadProfileImage() async throws -> UIImage? {
        let userUID = firebaseAuthService.getCurrentUserUID()
        let storage = Storage.storage().reference(withPath: "profileImages/\(userUID)")

        let url = try await storage.downloadURL()
        let (data, _) = try await URLSession.shared.data(from: url)

        guard let profileImage = UIImage(data: data) else { return nil}
        
        return profileImage
    }
}
