//
//  ImagePickerViewController.swift
//  PurrFinder
//
//  Created by Yann Rouzaud on 08/02/2023.
//

import SwiftUI

class ImagePickerViewModel: ObservableObject {
    @Published var image: UIImage?
    @Published var showPicker = false
//    @Published var source = "library"
    
    func showPhotoPicker() {
        showPicker = true
    }
}
