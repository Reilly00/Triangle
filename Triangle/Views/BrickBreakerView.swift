import SwiftUI
import SpriteKit

struct BrickBreakerView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var navbarVisibility: NavbarVisibility
    @EnvironmentObject var userDataStore: UserDataStore
    @State private var showingStartModal = true
    
    var scene: SKScene {
        let scene = BrickBreakerScene()
        scene.size = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        scene.scaleMode = .fill
        return scene
    }
    
    var body: some View {
        ZStack {
            VStack (spacing: 0) {
                TopNavigationBar(title: "Brick Breaker", onBack: { dismiss() })
                SpriteView(scene: scene)
                    .ignoresSafeArea()
            }
            
            if showingStartModal {
                BrickBreakerStartModal {
                    showingStartModal = false
                }
            }
        }
        .toolbarVisibility(.hidden)
        .onAppear {
            navbarVisibility.isVisible = false
        }
        .onDisappear {
            navbarVisibility.isVisible = true
        }
    }
}

#Preview {
    BrickBreakerView()
} 