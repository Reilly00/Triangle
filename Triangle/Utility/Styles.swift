//
//  Styles.swift
//  Triangle
//
//  Created by Josef Zemlicka on 18.01.2025.
//

import SwiftUI

// MARK: - Color Theme
struct ColorTheme {
    static let primary = Color(hex: 0x7297B1)
    static let darker = Color(hex: 0x1D272F)
    static let secondary = Color(hex: 0xDAE8F6)
    static let accent = Color(hex: 0x96B6CF)
    static let background = Color(hex: 0xB5CFE3)
    static let text = Color(hex: 0x4C708A)
    static let lightGray = Color(hex: 0xD9D9D9)
    static let shadowGray = Color.gray.opacity(0.4)
    static let green = Color(hex: 0x72B1A0)
    static let completedLevelColor = Color(hex: 0x72B1A0)
    static let currentLevelColor = Color(hex: 0x229374)
    static let lockedLevelColor = Color(hex: 0x7297B1).opacity(0.5)
    static let currencyColor = Color(hex:0xFFD145)
}

// MARK: - Font Styles (Dynamic Type Ready)
extension Font {
    static var textScale: CGFloat = 1.0
    static var pageTitle: Font {
        Font.system(size: 38 * textScale, weight: .black, design: .rounded)
    }
    static var cardTitle: Font {
        Font.system(size: 38 * textScale, weight: .black, design: .rounded)
    }
    static var pageSubtitle: Font {
        Font.system(size: 24 * textScale, weight: .black, design: .rounded)
    }
    static var bodyText: Font {
        Font.system(size: 18 * textScale, weight: .bold, design: .rounded)
    }
    static var buttonText: Font {
        Font.system(size: 20 * textScale, weight: .black, design: .rounded)
    }
    static var textFieldText: Font {
        Font.system(size: 18 * textScale, weight: .bold, design: .rounded)
    }
    static var shopCardTitle: Font {
        Font.system(size: 24 * textScale, weight: .bold, design: .rounded)
    }
}

// MARK: - Button Styles
struct TrianglePrimaryButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.buttonText)
            .foregroundColor(ColorTheme.secondary)
            .padding(.horizontal, 24).padding(.vertical, 12)
            .background(ColorTheme.primary)
            .cornerRadius(30)
            .overlay(
                RoundedRectangle(cornerRadius: 30)
                    .stroke(ColorTheme.primary, lineWidth: 2)
            )
            .shadow(color: ColorTheme.shadowGray, radius: 4, x: 2, y: 2)
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
    }
}

struct TriangleSecondaryButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.buttonText)
            .foregroundColor(ColorTheme.primary)
            .padding(.horizontal, 24).padding(.vertical, 12)
            .background(ColorTheme.secondary)
            .cornerRadius(30)
            .overlay(
                RoundedRectangle(cornerRadius: 30)
                    .stroke(ColorTheme.secondary, lineWidth: 2)
            )
            .shadow(color: ColorTheme.shadowGray, radius: 4, x: 2, y: 2)
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
    }
}

// MARK: - TextField Style
struct TriangleTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .font(.textFieldText)
            .padding(.horizontal, 20).padding(.vertical, 12)
            .background(ColorTheme.lightGray.opacity(0.1))
            .cornerRadius(30)
            .overlay(
                RoundedRectangle(cornerRadius: 30)
                    .stroke(ColorTheme.text, lineWidth: 2)
            )
            .multilineTextAlignment(.center)
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled(true)
            .shadow(color: ColorTheme.shadowGray, radius: 2, x: 1, y: 2)
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: 20) {
        Text("Page Title")
            .font(.pageTitle)
            .foregroundColor(ColorTheme.primary)
        Text("Subtitle")
            .font(.pageSubtitle)
            .foregroundColor(ColorTheme.secondary)
        Text("Body Text")
            .font(.bodyText)
            .foregroundColor(ColorTheme.text)
        Button("Primary Button") {}
            .buttonStyle(TrianglePrimaryButton())

        Button("Secondary Button") {}
            .buttonStyle(TriangleSecondaryButton())

        TextField("Enter text...", text: .constant(""))
            .textFieldStyle(TriangleTextFieldStyle())
    }
    .padding()
    .previewLayout(.sizeThatFits)
}
