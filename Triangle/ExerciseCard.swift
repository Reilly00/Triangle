//
//  ExerciseCard.swift
//  Triangle
//
//  Created by Josef Zemlicka on 09.01.2025.
//

import SwiftUI


struct ExerciseCard<Destination: View>: View {
    let title: String
    let imageNames: [String]
    let destination: Destination

    var body: some View {
        NavigationLink(destination: destination) {
            VStack(alignment: .leading, spacing: 10) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.primary)
                Spacer()
                HStack {
                    ForEach(imageNames, id: \.self) { imageName in
                        Image(imageName)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 450, height: 300)
                            .padding()
                    }
                }
                Spacer()
                Text("Exercise 1")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                ProgressView(value: 0.5)
                    .tint(.blue)
            }
            .padding()
            .frame(maxWidth: .infinity, minHeight: 500)
            .background(Color.white)
            .cornerRadius(10)
            .shadow(color: .gray.opacity(0.4), radius: 4, x: 2, y: 2)
        }
    }
}
