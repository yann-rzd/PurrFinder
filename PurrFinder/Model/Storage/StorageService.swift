//
//  StorageService.swift
//  PurrFinder
//
//  Created by Yann Rouzaud on 20/02/2023.
//

import Foundation
import FirebaseStorage

final class StorageService {
    
    // MARK: - PATTERN: singleton
    static let shared = StorageService()
    
    private init() {}
    
    
    // MARK: - INTERNAL: properties
    
    func persistProfileImageToStorage(image: UIImage) {
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
    
    func persistAnimalImageToStorage(image: UIImage) {
        let userUID = firebaseAuthService.getCurrentUserUID()
        let ref = Storage.storage().reference(withPath: "animalImages/\(userUID)")
        
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
    
    func downloadAnimalImage() async throws -> UIImage? {
        let userUID = firebaseAuthService.getCurrentUserUID()
        let storage = Storage.storage().reference(withPath: "animalImages/\(userUID)")

        let url = try await storage.downloadURL()
        let (data, _) = try await URLSession.shared.data(from: url)

        guard let animalImage = UIImage(data: data) else { return nil}
        
        return animalImage
    }
    
    func deleteUserProfileImageFromStorage() async throws {
        let userUID = firebaseAuthService.getCurrentUserUID()
        let ref = Storage.storage().reference(withPath: "profileImages/\(userUID)")
        
        do {
            try await ref.delete()
        } catch {
            throw error
        }
    }
    
    func deleteAnimalImageFromStorage() async throws {
        let userUID = firebaseAuthService.getCurrentUserUID()
        let ref = Storage.storage().reference(withPath: "animalImages/\(userUID)")
        
        do {
            try await ref.delete()
        } catch {
            throw error
        }
    }
    
    
    // MARK: - PRIVATE: properties
    
    private let firebaseAuthService = FirebaseAuthService.shared
}
