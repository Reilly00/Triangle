//
//  SoundManager.swift
//  Triangle
//
//  Created by Ciaran Mullen on 16/04/2025.
//

import AVKit
class SoundManager {
    static let instance = SoundManager()
    var player: AVAudioPlayer?
    enum SoundOption: String{
        case CloseBell
        case GameOver
        case Jump
        case NoNoNo
        case Notification
        case Positive
    }
    func playSound(sound: SoundOption) {
        guard let url = Bundle.main.url(forResource: sound.rawValue, withExtension: ".wav") else {
            print("Sound file not found.")
            return
        }

        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
        } catch {
            print("Error playing sound: \(error.localizedDescription)")
        }
    }
}
