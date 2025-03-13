//
//  LevelView.swift
//  Triangle
//
//  Created by Josef Zemlicka on 05.03.2025.
//

import SwiftUI

struct LevelView: View {
    let exerciseId: Int
    let levelId: Int

    var body: some View {
        VStack(spacing: 20) {
            Text("Exercise \(exerciseId) - Level \(levelId)")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()

            Text("Details for Level \(levelId) will be displayed here.")
                .font(.body)
                .multilineTextAlignment(.center)
                .padding()

            Spacer()
        }
        .padding()
        .navigationBarHidden(true)
    }
}

struct LevelView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            LevelView(exerciseId: 1, levelId: 3)
        }
    }
}
