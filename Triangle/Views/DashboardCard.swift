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
    let currentExercise: Int
    let locked: Bool?
    
    var body: some View {
        ZStack {
            if locked == true {
                // Non-interactive view when locked
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
                    Text("Exercise " + currentExercise.description)
                        .font(.headline)
                        .fontWeight(.medium)
                        .foregroundColor(Color(hex: 0x4C708A))
                    
                    ProgressView(value: progress)
                        .tint(Color(hex: 0x4C708A))
                }
                .padding()
                .background(Color(hex: 0x96B6CF))
                .cornerRadius(20)
                .opacity(0.5)  // Reduce opacity
                .grayscale(1.0) // Apply grayscale effect
                
                // Lock overlay
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.black.opacity(0.4))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                Image(systemName: "lock.fill")
                    .font(.system(size: 40, weight: .bold))
                    .foregroundColor(.white)
            } else {
                // Interactive NavigationLink when unlocked
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
                        Text("Exercise " + currentExercise.description)
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
    }
}



#Preview {
    return DashboardCard(title: "Preview", imageNames: ["VLogo"], destination: EmptyView(), progress: 0.5, currentExercise: 1, locked: false)
}
