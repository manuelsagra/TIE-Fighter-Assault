//
//  MenuViewController.swift
//  Tie Fighter Assault
//
//  Created by Manuel Sagra de Diego on 20/03/2019.
//  Copyright © 2019 Manuel Sagra. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
  
    // MARK: - Outlets
    @IBOutlet weak var hiScoreLabel: UILabel!
    private var musicPlayer: MusicPlayer?
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        musicPlayer = MusicPlayer(with: "Title")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        showHighScore()
        
        musicPlayer?.play()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        musicPlayer?.stop()
    }
    
    // MARK: - Events
    @IBAction func gameStartClicked(_ sender: Any) {
        self.present(GameViewController(), animated: false)
        SoundEffect.sharedInstance.play(sound: .gameStart)
    }
    
    private func showHighScore() {
        let hiScore = UserDefaults.standard.integer(forKey: Constants.hiScore)
        hiScoreLabel.text = String(format: "%08d", hiScore)
    }
}
