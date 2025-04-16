import SwiftUI
import SpriteKit

struct HoopsGameView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var navbarVisibility: NavbarVisibility
    @EnvironmentObject var userDataStore: UserDataStore
    @State private var showingStartModal = true
    @State private var gameScene: HoopsGameScene
    
    init() {
        let scene = HoopsGameScene()
        scene.size = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        scene.scaleMode = .aspectFill
        _gameScene = State(initialValue: scene)
    }
    
    var body: some View {
        ZStack {
            VStack (spacing: 0) {
                TopNavigationBar(
                    title: "Hoops",
                    onBack: { dismiss() }
                )
                SpriteView(scene: gameScene)
                    .ignoresSafeArea()
            }
            
            if showingStartModal {
                StartGameModal(
                    title: "Hoops",
                    description: "Swipe to catch the balls! Try to score as many baskets as you can.",
                    onStart: { 
                        showingStartModal = false
                        gameScene.startGame()
                    }
                )
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
    HoopsGameView()
} 