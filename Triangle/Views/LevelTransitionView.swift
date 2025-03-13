import RiveRuntime
import SwiftUI

struct LevelTransitionView: View {
    @EnvironmentObject var navbarVisibility: NavbarVisibility
    @State private var riveViewModel = RiveViewModel(
        fileName: "ch_t", animationName: "Timeline 1")
    let onCompletion: () -> Void
    @State private var displayedInfobite: String = ""

    // ✅ List of simple, child-friendly infobites
    private let infobites = [
        "Smiling can make you feel happier, even when you're sad!",
        "It's okay to feel angry sometimes, but taking deep breaths can help calm you down!",
        "When someone looks away a lot, they might feel shy or nervous.",
        "Crying isn’t bad—it helps let out big feelings!",
        "Hugs and kind words can help when a friend feels sad!",
    ]

    var body: some View {
        ZStack {
            Color(hex: 0xB5CFE3)
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 30) {  // Adjusted spacing between elements
                Spacer()  // Keeps content centered

                riveViewModel.view()
                    .frame(width: 300, height: 300)
                    .padding(.bottom, 20)  // Adds extra space below the animation

                ProgressView()
                    .progressViewStyle(
                        CircularProgressViewStyle(tint: Color(hex: 0x4C708A))
                    )
                    .scaleEffect(2)

                Spacer(minLength: 60)  // Moves text lower while keeping layout balanced

                // Infobite with improved background styling
                Text(displayedInfobite)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(Color(hex: 0x4C708A))
                    .multilineTextAlignment(.center)
                    .padding()
                    .frame(maxWidth: 320)
                    .background(Color(hex: 0x96B6CF).opacity(0.85))
                    .cornerRadius(15)
                    .shadow(
                        color: Color.black.opacity(0.2), radius: 5, x: 0, y: 3)

                Spacer()  // Ensures everything remains vertically balanced
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            navbarVisibility.isVisible = false
            displayedInfobite =
                infobites.randomElement()
                ?? "Emotions help us understand the world!"
            // After a delay, signal that the transition is complete.
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                onCompletion()
            }
        }
    }
}
