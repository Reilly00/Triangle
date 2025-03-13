//
//  DashboardCard.swift
//  Triangle
//
//  Created by Josef Zemlicka on 09.01.2025.
//

import SwiftUI

struct DashboardCard: View {
    let title: String
    let imageNames: [String]
    let progress: Double
    let currentExercise: Int
    let locked: Bool?
    let action: () -> Void

    var body: some View {
        ZStack {
            if locked == true {
                // Locked state: non-interactive UI
                VStack(alignment: .leading, spacing: 15) {
                    Text(title)
                        .font(.cardTitle)
                        .foregroundColor(Color(hex: 0x4C708A))
                    Spacer()
                    HStack {
                        ForEach(imageNames, id: \.self) { imageName in
                            Image(imageName)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(maxWidth: .infinity, alignment: .center)
                        }
                    }
                    Spacer()
                    Spacer()
                    Spacer()
                }
                .padding()
                .background(Color(hex: 0x96B6CF))
                .cornerRadius(20)
                // Overlay lock
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.black.opacity(0.4))
                Image(systemName: "lock.fill")
                    .font(.system(size: 150, weight: .bold, design: .rounded))
                    .foregroundColor(ColorTheme.secondary)
            } else {
                // Unlocked: wrap content in a Button that calls the provided action
                Button(action: action) {
                    VStack(alignment: .leading, spacing: 15) {
                        Text(title)
                            .font(.cardTitle)
                            .foregroundColor(Color(hex: 0x4C708A))
                        Spacer()
                        HStack {
                            ForEach(imageNames, id: \.self) { imageName in
                                Image(imageName)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(maxWidth: .infinity, alignment: .center)
                            }
                        }
                        Spacer()
                        Text("Exercise \(currentExercise)")
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
    HStack {
        DashboardCard(
            title: "Preview", imageNames: ["VLogo"], progress: 0.5,
            currentExercise: 2, locked: false, action: ({} as () -> Void))
        DashboardCard(
            title: "Preview", imageNames: ["VLogo"], progress: 0.5,
            currentExercise: 2, locked: true, action: ({} as () -> Void))
    }
    .frame(width: 1000, height: 500)
}
