//
//  CurrentAlertPageView.swift
//  PurrFinder
//
//  Created by Yann Rouzaud on 24/02/2023.
//

import SwiftUI

struct CurrentAlertView: View {
    @StateObject var viewModel = CurrentAlertViewModel()
    @State private var showMap = false
    
    var body: some View {
        VStack {
            if let image = viewModel.animalImage {
                Image(uiImage: image)
                    .resizable()
                    .frame(width: 120, height: 120)
                    .clipShape(Circle())
            } else {
                Image(uiImage: UIImage(imageLiteralResourceName: "Cat"))
                    .resizable()
                    .frame(width: 120, height: 120)
                    .clipShape(Circle())
            }
            
            Text(viewModel.animalName)
            Text(viewModel.animalType)
            Text(viewModel.animalBreed)
            Text(viewModel.animalDescription)
            Text(viewModel.animalLostDate)
            
            Button(action: {
                showMap = true
            }) {
                Image(systemName: "map.fill")
                    .resizable()
                    .frame(width: 25, height: 25)
                    .padding(.top, 50)
            }
        }
        .fullScreenCover(isPresented: $showMap, content: {
            MapModalView(isPresented: $showMap)
        })
        .task {
            do {
                try await viewModel.getCurrentAlertData()
            } catch {
                // handle error
            }
        }
        
    }
}

struct CurrentAlertPageView_Previews: PreviewProvider {
    static var previews: some View {
        CurrentAlertView()
    }
}
