//
//  ContentView.swift
//  CryptoApp
//
//  Created by Alik Nigay on 01.04.2023.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            Color.theme.background
                .ignoresSafeArea()
            VStack(spacing: 40) {
                Text("Accent Color")
                    .foregroundColor(Color.theme.accent)
                
                Text("Secondary text color")
                    .foregroundColor(Color.theme.secondaryText)
                
                Text("Red color")
                    .foregroundColor(Color.theme.red)
                
                Text("Green color")
                    .foregroundColor(Color.theme.green)
            }
            .font(.headline)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
