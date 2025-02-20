//
//  Navbar.swift
//  Triangle
//
//  Created by Josef Zemlicka on 22.01.2025.
//

import SwiftUI

struct Navbar: View {
    var body: some View {
        HStack {
            Spacer()
            HStack(spacing: 16) {
                NavigationLink(destination: ProfileView().environmentObject(SettingsViewModel())) {
                    ZStack {
                        Circle()
                            .fill(Color.gray.opacity(0.3))
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .frame(width: 24, height: 24)
                    }
                }
                .buttonStyle(NavbarButton())
                NavigationLink(destination: SettingsView()) {
                    Image(systemName: "gearshape.fill")
                        .resizable()
                        .frame(width: 24, height: 24)
                    
                }
                .buttonStyle(NavbarButton())
            }
            .padding(.horizontal, 20)
        }
        .padding(.top, 20)
        
        
    }
}
