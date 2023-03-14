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
                .navigationBarTitle("", displayMode: .inline)
                .navigationBarItems(trailing: Button(action: {
                        self.isPresented.toggle()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title)
                            .foregroundColor(Color("BluePurr"))
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

