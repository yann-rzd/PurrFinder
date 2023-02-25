//
//  MapModalView.swift
//  PurrFinder
//
//  Created by Yann Rouzaud on 25/02/2023.
//

import SwiftUI
import MapKit

struct MapModalView: View {
    @StateObject var viewModel = MapModalViewModel()
    @Binding var isPresented: Bool
    
    var body: some View {
        NavigationView {
            MapView(latitude: viewModel.ownerLatitude, longitude: viewModel.ownerLongitude)
                .ignoresSafeArea()
                .navigationBarTitle("", displayMode: .inline)
                .navigationBarBackButtonHidden(true)
                .navigationBarItems(leading: Button(action: {
                    self.isPresented.toggle()
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.blue)
                        Text("Back")
                    }
                    
                })
        }
    }
    
}

