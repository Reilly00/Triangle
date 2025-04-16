import RiveRuntime
import SwiftUI

struct Character: View {
    let characterData: CharacterData
    var useAnimations: Bool

    @State private var riveViewModel = RiveViewModel(
        fileName: "character_idle", animationName: "Timeline 1"
    )

    var body: some View {
        // Enforce a 1:1 aspect ratio for the character view.
        // This lets you use the character in any size and the cosmetics will be scaled accordingly
        // Idk if this is the best approach but it works :D
        ZStack {
            if !useAnimations {
                    Color.white // Debug background
            }
            GeometryReader { geometry in
                let frameSize = min(geometry.size.width, geometry.size.height)

                ZStack {
                    if !useAnimations {
                        Image("character_base")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: frameSize, height: frameSize)
                    } else {
                        riveViewModel.view()
                            .frame(width: frameSize, height: frameSize)
                            .clipped()
                    }
                    // HEAD COSMETIC
                    Image(characterData.headCosmetic.assetName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .rotationEffect(
                            Angle(degrees: characterData.headCosmetic.rotation),
                            anchor: .center
                        )
                        .scaleEffect(characterData.headCosmetic.relativeScale)
                        .offset(
                            x: frameSize
                                * characterData.headCosmetic.offsetXRatio,
                            y: frameSize
                                * characterData.headCosmetic.offsetYRatio
                        )

                    // EYE COSMETIC
                    Image(characterData.eyeCosmetic.assetName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .scaleEffect(characterData.eyeCosmetic.relativeScale)
                        .offset(
                            x: frameSize
                                * characterData.eyeCosmetic.offsetXRatio,
                            y: frameSize
                                * characterData.eyeCosmetic.offsetYRatio
                        )
                }
                // Center the ZStack in the container.
                .frame(width: frameSize, height: frameSize)
                .position(
                    x: geometry.size.width / 2, y: geometry.size.height / 2)
            }
        }
        // This forces 1:1 aspect ratio
        .aspectRatio(1, contentMode: .fit)
    }
}

#Preview {
    Character(characterData: CharacterData.defaultCharacter, useAnimations: true)
        .frame(height: 500)
        .padding()
}
