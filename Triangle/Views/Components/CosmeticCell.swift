//
//  CosmeticCell.swift
//  Triangle
//
//  Created by Josef Zemlicka on 13.03.2025.
//

import SwiftUI

struct CosmeticCell: View {
    let cosmeticTitle: String
    let assetName: String
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack {
                Image(assetName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(
                        minWidth: 150, maxWidth: 150, minHeight: 150,
                        maxHeight: 150)
                Text(cosmeticTitle)
                    .font(.caption)
                    .foregroundColor(ColorTheme.text)
            }
            .padding(8)
            .background(ColorTheme.secondary.opacity(0.3))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(
                        isSelected ? ColorTheme.currentLevelColor : Color.clear,
                        lineWidth: isSelected ? 5 : 0)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

