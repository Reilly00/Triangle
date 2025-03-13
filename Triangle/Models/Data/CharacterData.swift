//
//  Character.swift
//  Triangle
//
//  Created by Josef Zemlicka on 08.03.2025.
//

import Foundation

struct CharacterData: Codable, Equatable {
    var eyeCosmetic: EyeCosmetic
    var headCosmetic: HeadCosmetic
    var colorId: Int
}

extension CharacterData {
    
    static let defaultCharacter: CharacterData = CharacterData(
        eyeCosmetic: EyeCosmetic.defaultCosmetic,
        headCosmetic: HeadCosmetic.defaultCosmetic,
        colorId: 1
    )
    
}
