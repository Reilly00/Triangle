//
//  DashboardCard.swift
//  Triangle
//
//  Created by Josef Zemlicka on 09.01.2025.
//

import SwiftUI

struct ExerciseCard: View {
    @EnvironmentObject var userDataStore: UserDataStore
    @State private var currentLevel: Int = 0
    let id: Int
    let isLocked: Bool
    
    init(id: Int, isLocked: Bool = false) {
        self.id = id
        self.isLocked = isLocked
    }

    var body: some View {
        let title = "Exercise \(id)"
        let imageName = "SocialTriangle"
        VStack(alignment: .leading, spacing: 15) {
            Text(title)
                .font(.cardTitle)
                .foregroundColor(Color(hex: 0x4C708A))
            Spacer()
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: .infinity, alignment: .center)
            Spacer()
            Text("Level \(currentLevel)")
                .font(.headline)
                .fontWeight(.medium)
                .foregroundColor(Color(hex: 0x4C708A))
            ProgressView(value: userDataStore.caltulateNormalizedProgress(exerciseId: self.id))
                .tint(Color(hex: 0x4C708A))
        }
        .padding()
        .background(Color(hex: 0x96B6CF))
        .cornerRadius(20)
        .overlay(
            Group {
                if isLocked {
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(ColorTheme.darker.opacity(0.7))
                        
                        Image(systemName: "lock.fill")
                            .font(.system(size: 50))
                            .foregroundColor(.white)
                    }
                }
            }
        )
        .onAppear {
            currentLevel = userDataStore.getCurrentLevel(exerciseId: self.id)
        }
    }
}

#Preview {
    HStack {
        ExerciseCard(id: 1)
            .environmentObject(UserDataStore(userId: "guest"))
        ExerciseCard(id: 2, isLocked: true)
            .environmentObject(UserDataStore(userId: "guest"))
    }
    .frame(width: 1000, height: 500)
}
