//
//  CryptoAppApp.swift
//  CryptoApp
//
//  Created by Alik Nigay on 01.04.2023.
//

import SwiftUI

@main
struct CryptoAppApp: App {
    
    @StateObject private var homeViewModel = HomeViewModel()
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                HomeView()
                    .navigationBarHidden(true)
            }
            .environmentObject(homeViewModel)
        }
    }
}
