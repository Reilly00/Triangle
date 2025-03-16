//
//  ShopCard.swift
//  Triangle
//
//  Created by Josef Zemlicka on 12.03.2025.
//

import SwiftUI

struct ShopCard: View {
    let cosmetic: any Cosmetic
    let isUnlocked: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(hex: 0x96B6CF))
                    .shadow(color: .gray.opacity(0.2), radius: 5, x: 0, y: 3)

                VStack(spacing: 8) {
                    ZStack {
                        Rectangle()
                            .fill(Color(hex: 0xDAE8F6))
                            .cornerRadius(20)

                        // Cosmetic image
                        Image(cosmetic.assetName)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: .infinity)
                            .padding()
                    }
                    .padding(.top, 10)

                    Spacer(minLength: 0)

                    // Cosmetic title
                    Text(cosmetic.cosmeticTitle)
                        .font(.pageSubtitle)
                        .foregroundColor(Color(hex: 0x4C708A))

                    // Either show "Unlocked" or the price row.
                    if isUnlocked {
                        Text("Owned")
                            .font(.shopCardTitle)
                            .foregroundColor(ColorTheme.currentLevelColor)
                            .padding(.bottom, 10)
                    } else {
                        HStack(spacing: 5) {
                            Text("\(cosmetic.price)")
                                .font(.shopCardTitle)
                                .foregroundColor(ColorTheme.currencyColor)

                            Image("currency_icon")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 18, height: 18)
                        }
                        .padding(.bottom, 10)
                    }
                }
                .padding(.horizontal, 10)
            }
            .frame(height: 300)
        }
        .buttonStyle(.plain)
    }
}

struct ShopCard_Previews: PreviewProvider {
    // Sample data for preview
    static let sampleCosmetics: [any Cosmetic] = [
        HeadCosmetic(
            cosmeticId: 1,
            assetName: "hc_beanie",
            cosmeticTitle: "Beanie",
            relativeScale: 0.8,
            offsetXRatio: 0,
            offsetYRatio: 0,
            rotation: 0,
            price: 10
        ),
        EyeCosmetic(
            cosmeticId: 2,
            assetName: "ec_sunglasses",
            cosmeticTitle: "Sunglasses",
            relativeScale: 0.6,
            offsetXRatio: 0,
            offsetYRatio: 0,
            rotation: 0,
            price: 10
        ),
    ]

    static var previews: some View {
        HStack {
            ForEach(sampleCosmetics, id: \.cosmeticId) { cosmetic in
                // For preview, mark the first cosmetic as unlocked and the second as not.
                ShopCard(
                    cosmetic: cosmetic, isUnlocked: cosmetic.cosmeticId == 1
                ) {
                    // Action for tap
                }
            }
        }
    }
}
