//
//  File.swift
//  Tie Fighter Assault
//
//  Created by Manuel Sagra de Diego on 23/03/2019.
//  Copyright © 2019 Manuel Sagra. All rights reserved.
//

import AVFoundation

class MusicPlayer {
    
    // MARK: - Properties
    private var player: AVAudioPlayer?
    
    // MARK: - Initialization
    init(with music: String) {
        do {
            if let fileURL = Bundle.main.path(forResource: music, ofType: "mp3") {
                player = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: fileURL))
                player?.numberOfLoops = -1
                player?.prepareToPlay()
            }
        } catch let error {
            print ("Error playing music file \(error.localizedDescription)")
        }
    }
    
    // MARK: - Events
    func play() {
        player?.play()
    }
    
    func stop() {
        player?.stop()
        player?.currentTime = 0
    }
    
    func pause() {
        player?.pause()
    }
}
