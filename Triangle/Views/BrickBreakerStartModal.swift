import SwiftUI

struct BrickBreakerStartModal: View {
    let onStart: () -> Void
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.5)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text("Brick Breaker")
                    .font(.pageTitle)
                    .foregroundColor(.white)
                
                Text("Break all the bricks to win!")
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
    BrickBreakerStartModal(onStart: {})
} 