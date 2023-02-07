//
//  NavigationTabView.swift
//  PurrFinder
//
//  Created by Yann Rouzaud on 07/02/2023.
//

import SwiftUI

struct NavigationTabView: View {
    @State private var selectedTab = 1
    
    init() {
        
        UITabBar.appearance().backgroundColor = UIColor(Color("BluePurr"))
        //        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 50)], for: .normal)
        //        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 50)], for: .selected)
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            UserProfileView()
                .tabItem {
                    Image(systemName: "person.crop.circle.fill")
                        .foregroundColor(.red)
                        .font(.largeTitle)
                        .imageScale(.large)
                }
                .tag(0)
            
            AlertPageView()
                .tabItem {
                    Image(systemName: "bell.fill")
                        .font(.largeTitle)
                    
                }
                .tag(1)
            
            ChatHelpView()
                .tabItem {
                    Image(systemName: "text.bubble.fill")
                        .font(.largeTitle)
                    
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
