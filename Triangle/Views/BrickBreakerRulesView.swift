import SwiftUI

struct BrickBreakerRulesView: View {
    @Binding var isPresented: Bool
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        // Modal content
        VStack(spacing: 20) {
            // Title
            Text("Brick Breaker")
                .font(.pageTitle)
                .foregroundColor(ColorTheme.primary)
            
            // Rules
            VStack(alignment: .leading, spacing: 15) {
                RuleRow(icon: "🎯", text: "Break all the bricks to win")
                RuleRow(icon: "🔄", text: "Each round gets harder with more bricks")
                RuleRow(icon: "❤️", text: "You have 3 lives")
                RuleRow(icon: "🏓", text: "Use the paddle to bounce the ball")
                RuleRow(icon: "🎮", text: "Move the paddle by dragging")
            }
            .padding(.horizontal)
            .padding(.vertical, 20)
            
            // Start button
            Button(action: {
                isPresented = false
                dismiss()
            }) {
                Text("Press to Start")
                    .font(.buttonText)
                    .foregroundColor(ColorTheme.secondary)
                    .frame(width: 200, height: 50)
                    .background(ColorTheme.primary)
                    .cornerRadius(30)
                    .overlay(
                        RoundedRectangle(cornerRadius: 30)
                            .stroke(ColorTheme.primary, lineWidth: 2)
                    )
                    .shadow(color: ColorTheme.shadowGray, radius: 4, x: 2, y: 2)
            }
            .padding(.top, 20)
        }
        .padding(30)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(color: ColorTheme.shadowGray, radius: 10)
        )
        .padding(.horizontal, 40)
        .padding(.vertical, 60)
    }
}

struct RuleRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 15) {
            Text(icon)
                .font(.system(size: 24))
            Text(text)
                .font(.bodyText)
                .foregroundColor(ColorTheme.text)
            Spacer()
        }
    }
}

#Preview {
    BrickBreakerRulesView(isPresented: .constant(true))
} 