import Foundation

struct HoopsGameModel {
    var score: Int = 0
    var basketPosition: CGFloat = 0 // Horizontal position of the basket
    var isGameActive: Bool = true
    var highScore: Int = 0
    
    // Constants for the game
    static let basketWidth: CGFloat = 100
    static let basketHeight: CGFloat = 80
    static let screenPadding: CGFloat = 50 // Minimum distance from screen edges
} 