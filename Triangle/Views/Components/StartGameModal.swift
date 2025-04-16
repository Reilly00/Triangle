import SwiftUI

struct StartGameModal: View {
    let title: String
    let description: String
    let onStart: () -> Void
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.5)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text(title)
                    .font(.pageTitle)
                    .foregroundColor(.white)
                
                Text(description)
                    .font(.bodyText)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                Button(action: onStart) {
                    Text("Start Game")
                        .font(.buttonText)
                        .foregroundColor(ColorTheme.secondary)
                        .frame(width: 200, height: 50)
                        .background(ColorTheme.primary)
                        .cornerRadius(25)
                }
            }
            .padding(30)
            .background(ColorTheme.background)
            .cornerRadius(20)
            .shadow(color: ColorTheme.shadowGray, radius: 10, x: 0, y: 5)
        }
    }
}

#Preview {
    StartGameModal(
        title: "Game Title",
        description: "Game description goes here",
        onStart: {}
    )
} 