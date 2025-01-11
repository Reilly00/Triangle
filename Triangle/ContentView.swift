//
//  ContentView.swift
//  Triangle
//
//  Created by Josef Zemlicka on 02.01.2025.
//

import SwiftUI

struct DashboardView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    HStack {
                        Spacer()
                        HStack(spacing: 16) {
                            NavigationLink(destination: DetailView(title: "Profile")) {
                                Text("Profile")
                            }
                            .buttonStyle(NavbarButton())
                            NavigationLink(destination: DetailView(title: "Settings")) {
                                Image(systemName: "gearshape.fill")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                
                            }
                            .buttonStyle(NavbarButton())
                        }
                        .padding(.horizontal, 20)
                    }
                    .padding(.top, 20)
                    
                    VStack(spacing: 40) {
                        ForEach(0..<2, id: \.self) { row in
                            HStack(spacing: 40) {
                                DashboardCard(title: "Social", imageNames: ["SocialTriangle"], destination: DetailView(title: "Social"), progress: 0.5)
                                DashboardCard(title: "Focus & Attention", imageNames: ["SocialTriangle"], destination: DetailView(title: "Focus & Attention"), progress: 0.3)
                            }
                            .frame(maxWidth: .infinity)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                }
                .padding()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(hex: 0xB5CFE3))
            .edgesIgnoringSafeArea(.all)
        }
    }
}

struct DetailView: View {
    let title: String
    
    var body: some View {
        VStack {
            Text("You are in the " + title + " view!")
        }
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
            .previewInterfaceOrientation(.landscapeLeft)
            .previewDevice("iPad Pro 11-inch")
    }
}

struct DashboardCard<Destination: View>: View {
    let title: String
    let imageNames: [String]
    let destination: Destination
    let progress: Double
    
    var body: some View {
        NavigationLink(destination: destination) {
            VStack(alignment: .leading, spacing: 15) {
                Text(title)
                    .font(.largeTitle)
                    .fontWeight(.black)
                    .foregroundColor(Color(hex: 0x4C708A))
                
                Spacer()
                HStack {
                    ForEach(imageNames, id: \.self) { imageName in
                        Image(imageName)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    }
                }
                Spacer()
                Text("Exercise 1")
                    .font(.headline)
                    .fontWeight(.medium)
                    .foregroundColor(Color(hex: 0x4C708A))
                
                ProgressView(value: progress)
                    .tint(Color(hex: 0x4C708A))
            }
            .padding()
            .background(Color(hex: 0x96B6CF))
            .cornerRadius(20)
        }
    }
}

struct NavbarButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(height: 20)
            .padding()
            .foregroundColor(Color(hex: 0x4C708A))
            .font(.headline)
            .fontWeight(.black)
            .background(Color(hex: 0xD9D9D9))
            .foregroundStyle(.white)
            .cornerRadius(60)
            .shadow(color: .gray.opacity(0.4), radius: 4, x: 2, y: 2)
    }
}

extension Color {
    init(hex: Int, opacity: Double = 1.0) {
        let red = Double((hex & 0xff0000) >> 16) / 255.0
        let green = Double((hex & 0xff00) >> 8) / 255.0
        let blue = Double((hex & 0xff) >> 0) / 255.0
        self.init(.sRGB, red: red, green: green, blue: blue, opacity: opacity)
    }
}
