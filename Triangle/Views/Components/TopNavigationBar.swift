//
//  TopNavigationBar.swift
//  Triangle
//
//  Created by Josef Zemlicka on 25.02.2025.
//

import SwiftUI

struct TopNavigationBar: View {
    let title: String
    let onBack: (() -> Void)?

    var body: some View {
        HStack {
            if let onBack = onBack {
                Button(action: {
                    onBack()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 32, weight: .black))
                        .foregroundColor(ColorTheme.text)
                }
                .padding(.leading, 16)
            } else {
                // A placeholder to maintain spacing
                Spacer().frame(width: 44)
            }

            Spacer()

            Text(title)
                .font(.pageTitle)
                .foregroundColor(ColorTheme.text)
                .frame(maxWidth: .infinity, alignment: .center)

            Spacer().frame(width: 44)
        }
        .frame(height: 100)
        .background(ColorTheme.background)
    }
}

#Preview {
    TopNavigationBar(title: "Page Title", onBack: ({} as () -> Void))
    TopNavigationBar(title: "Page Title", onBack: nil)
}
