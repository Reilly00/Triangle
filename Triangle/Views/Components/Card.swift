//
//  Card.swift
//  Triangle
//
//  Created by Josef Zemlicka on 23.01.2025.
//

import SwiftUI

struct Card: View {
    let title: String
    let imageName: String
    
    var body: some View {
        ZStack() {
            VStack(alignment: .leading, spacing: 15) {
                Text(title)
                    .font(.largeTitle)
                    .fontWeight(.black)
                    .foregroundColor(Color(hex: 0x4C708A))
                
                Spacer()
                HStack {
                    Image(imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }
            }
            Spacer()
        }
        .padding()
        .background(Color(hex: 0x96B6CF))
        .cornerRadius(20)
    }
}

struct Card_Previews: PreviewProvider {
    static var previews: some View {
        Card(title: "Title", imageName: "VLogo")
            .previewDevice("iPad Pro 11-inch")
    }
}
