//
//  DashboardCard.swift
//  Triangle
//
//  Created by Josef Zemlicka on 09.01.2025.
//

import SwiftUI


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

#Preview {
    return DashboardCard(title: "Preview", imageNames: ["VLogo"], destination: EmptyView(), progress: 0.5)
}
