//
//  SoundEffect.swift
//  Tie Fighter Assault
//
//  Created by Manuel Sagra de Diego on 23/03/2019.
//  Copyright © 2019 Manuel Sagra. All rights reserved.
//

import AVFoundation

enum Effect: String {
    case laser = "Laser"
    case protonTorpedo = "ProtonTorpedo"
    
    case hit = "Hit"
    case playerHit = "PlayerHit"
    
    case asteroidExplossion = "AsteroidExplossion"
    case tieFighterExplossion = "TieFighterExplossion"
    case tieFighterFlyby = "TieFighterFlyby"
    
    case bonusShield = "BonusShield"
    case bonusProtonTorpedoes = "BonusProtonTorpedoes"
    
    case gameStart = "GameStart"
    case gameOver = "GameOver"
}

class SoundEffect: NSObject {
    
    static let sharedInstance = SoundEffect()
    
    // MARK: - Properties
    var players: [AVAudioPlayer] = []
    
    override init() {
        super.init()
    }

    // MARK: - Player
    func play(sound effect: Effect) {
        do {
            if let fileURL = Bundle.main.path(forResource: effect.rawValue, ofType: "mp3") {
                let player = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: fileURL))
                player.delegate = self
                player.prepareToPlay()
                player.play()
                players.append(player)
            }
        } catch let error {
            print ("Error playing sound file \(error.localizedDescription)")
        }
    }
    
}

extension SoundEffect: AVAudioPlayerDelegate {
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        players.forEach { currentPlayer in
            if !currentPlayer.isPlaying, let index = players.index(of: player) {
                players.remove(at: index)
            }
        }
    }
    
}
