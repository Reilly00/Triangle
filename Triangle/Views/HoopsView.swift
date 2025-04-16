import SwiftUI
import SpriteKit

struct HoopsView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var navbarVisibility: NavbarVisibility
    @EnvironmentObject var userDataStore: UserDataStore
    
    var scene: SKScene {
        let scene = HoopsGameScene()
        scene.size = UIScreen.main.bounds.size
        scene.scaleMode = .fill
        return scene
    }
    
    var body: some View {
        ZStack {
            // Game Scene
            SpriteView(scene: scene)
                .ignoresSafeArea()
            
            // Top Navigation Bar
            VStack {
                TopNavigationBar(
                    title: "Hoops",
                    onBack: { presentationMode.wrappedValue.dismiss() }
                )
                Spacer()
            }
        }
        .onAppear {
            navbarVisibility.isVisible = false
        }
        .onDisappear {
            navbarVisibility.isVisible = true
        }
    }
} 