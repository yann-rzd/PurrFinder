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
    @State private var centerCoordinate = CLLocationCoordinate2D()
    @Binding var isPresented: Bool
    
    var body: some View {
        NavigationView {
            MapView(centerCoordinate: $centerCoordinate)
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
                .onAppear {
                    Task {
                        try await viewModel.getOwnerLocation()
                        centerCoordinate = CLLocationCoordinate2D(latitude: viewModel.ownerLatitude, longitude: viewModel.ownerLongitude)
                    }
                }
        }
    }
}

