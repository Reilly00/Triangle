//
//  Styles.swift
//  Triangle
//
//  Created by Josef Zemlicka on 18.01.2025.
//

import SwiftUI

// Define a central color theme
struct ColorTheme {
    static let primary = Color(hex: 0x4C708A)
    static let secondary = Color(hex: 0xDAE8F6)
    static let accent = Color(hex: 0x96B6CF)
    static let background = Color(hex: 0xB5CFE3)
    static let text = Color(hex: 0x4C708A)
    static let lightGray = Color(hex: 0xD9D9D9)
    static let shadowGray = Color.gray.opacity(0.4)
}

// Define Montserrat font styles
// TODO: Find a way to import variable fonts as this is not working
extension Font {
    static let montserratHeadline = Font.custom("Montserrat-Bold", size: 18)
    static let montserratTitle = Font.custom("Montserrat-Bold", size: 24)
    static let montserratBody = Font.custom("Montserrat-Regular", size: 16)
}

struct NavbarButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(height: 20)
            .padding()
            .foregroundColor(ColorTheme.text)
            .font(.title2)
            .fontWeight(.black)
            .background(ColorTheme.lightGray)
            .cornerRadius(60)
            .shadow(color: ColorTheme.shadowGray, radius: 4, x: 2, y: 2)
    }
}

struct TrianglePrimaryButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(minWidth: 50, minHeight: 20)
            .padding(.vertical, 15)
            .foregroundColor(ColorTheme.secondary)
            .font(.title2)
            .fontWeight(.black)
            .background(ColorTheme.primary)
            .cornerRadius(60)
            .overlay(
                RoundedRectangle(cornerRadius: 60)
                    .stroke(ColorTheme.primary, lineWidth: 3)
            )
    }
}

struct TriangleSecondaryButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(height: 20)
            .padding(.vertical, 15)
            .foregroundColor(ColorTheme.primary)
            .font(.title2)
            .fontWeight(.black)
            .background(ColorTheme.secondary)
            .cornerRadius(60)
            .overlay(
                RoundedRectangle(cornerRadius: 60)
                    .stroke(ColorTheme.secondary, lineWidth: 3)
            )
    }
}

struct TriangleTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .frame(height: 20)
            .padding(.vertical, 15)
            .background(ColorTheme.lightGray.opacity(0.1))
            .cornerRadius(60)
            .font(.title2)
            .fontWeight(.black)
            .foregroundColor(ColorTheme.text)
            .overlay(
                RoundedRectangle(cornerRadius: 60)
                    .stroke(ColorTheme.text, lineWidth: 3)
            )
            .multilineTextAlignment(.center)
            .autocapitalization(.none)
            .autocorrectionDisabled(true)
    }
}
