//
//  ImagePickerViewController.swift
//  PurrFinder
//
//  Created by Yann Rouzaud on 08/02/2023.
//

import SwiftUI
import Photos
import PhotosUI

class ImagePickerViewModel: ObservableObject {
    @Published var image: UIImage?
    @Published var showPicker = false
    @Published var source: Picker.Source = .library
    
    func showPhotoPicker() {
        showPicker = true
    }
}
