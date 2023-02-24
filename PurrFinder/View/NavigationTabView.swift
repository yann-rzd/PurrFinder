//
//  NavigationTabView.swift
//  PurrFinder
//
//  Created by Yann Rouzaud on 07/02/2023.
//

import SwiftUI


struct NavigationTabView: View {
    @State private var selectedTab = 1
    
    var body: some View {
        TabView(selection: $selectedTab) {
            ChatHelpView()
                .tabItem {
                    Image(systemName: "text.bubble.fill")
                        .font(.system(size: 50))
                }
                .tag(0)
            
            AlertPageView()
                .tabItem {
                    Image(systemName: "bell.fill")
                        .font(.system(size: 50))
                    
                }
                .tag(1)
            
            UserProfileView()
                .tabItem {
                    Image(systemName: "person.crop.circle.fill")
                        .font(.system(size: 50))
                    
                }
                .tag(2)
        }
        .background(Color(.brown))
    }
}

struct NavigationTabView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationTabView()
    }
}
