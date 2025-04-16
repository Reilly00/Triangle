//
//  DashboardCard.swift
//  Triangle
//
//  Created by Josef Zemlicka on 09.01.2025.
//

import SwiftUI

struct DashboardCard: View {
    var title: String
    var imageName: String
    
    var body: some View {
        ZStack {
                VStack(alignment: .leading, spacing: 15) {
                    Text(title)
                        .font(.cardTitle)
                        .foregroundColor(Color(hex: 0x4C708A))
                    Spacer()
                    HStack {
                        Image(imageName)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
            }
            .padding()
            .background(Color(hex: 0x96B6CF))
            .cornerRadius(20)
        }
    }


#Preview {
    HStack {
        DashboardCard(
            title: "Exercises", imageName: "exercises_mascot")
        DashboardCard(
            title: "Minigames", imageName: "minigames_mascot")
    }
    .frame(width: 1000, height: 500)
}
