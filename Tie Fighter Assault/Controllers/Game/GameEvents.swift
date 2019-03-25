//
//  GameEvents.swift
//  Tie Fighter Assault
//
//  Created by Manuel Sagra de Diego on 23/03/2019.
//  Copyright © 2019 Manuel Sagra. All rights reserved.
//

import ARKit

extension GameViewController {
    
    // MARK: - Tap Events
    @IBAction func ejectClicked(_ sender: Any) {
        pause()
        
        let alertController = UIAlertController(title: Constants.ejectTitle, message: Constants.ejectMessage, preferredStyle: .alert)
        let ejectAction = UIAlertAction(title: "Eject", style: .default) { (_) -> Void in
            self.gameOver()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (_) -> Void in
            self.resume()
        }
        alertController.addAction(cancelAction)
        alertController.addAction(ejectAction)
        
        self.present(alertController, animated: true)
    }
    
    @objc func tapScreen() {
        guard let camera = sceneView.session.currentFrame?.camera else { return }
        
        let shoot = Shoot(camera: camera, type: currentWeapon)
        sceneView.scene.rootNode.addChildNode(shoot)
        
        if currentWeapon == .ProtonTorpedoes {
            updateProtonTorpedoes(increment: -1)
            DispatchQueue.main.async {
                SoundEffect.sharedInstance.play(sound: .protonTorpedo)
            }
        } else {
            DispatchQueue.main.async {
                SoundEffect.sharedInstance.play(sound: .laser)
            }
        }
    }
    
    @objc func tapLaser() {
        currentWeapon = .Laser
        updateWeaponUI()
    }
    
    @objc func tapProtonTorpedoes() {
        if protonTorpedoes > 0 {
            currentWeapon = .ProtonTorpedoes
            updateWeaponUI()
        }
    }
    
    // MARK: - Game Events
    func pause() {
        // Scene and nodes
        sceneView.session.pause()
        let nodes = sceneView.scene.rootNode.childNodes
        nodes.forEach { node in
            node.isPaused = true
            if let shoot = node as? Shoot {
                shoot.pauseForce()
            }
        }
        
        asteroidTimer.invalidate()
        musicPlayer?.pause()
    }
    
    func resume() {
        // Scene and nodes
        sceneView.session.run(arConfiguration)
        let nodes = sceneView.scene.rootNode.childNodes
        nodes.forEach { node in
            node.isPaused = false
            if let shoot = node as? Shoot {
                shoot.resumeForce()
            }
        }
        
        asteroidTimer = Timer.scheduledTimer(timeInterval: Constants.asteroidSpawnTime, target: self, selector: #selector(addAsteroid), userInfo: nil, repeats: true)
        musicPlayer?.play()
    }
    
    func gameOver() {
        pause()
        
        DispatchQueue.main.async {
            SoundEffect.sharedInstance.play(sound: .gameOver)
        
            var message = Constants.gameOverMessage
            if self.checkHighScore() {
                message = "\(message)\n\nNew high score, congratulations!"
            }
            let alertController = UIAlertController(title: Constants.gameOverTitle, message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Accept", style: .default, handler: { (_) -> Void in
                self.dismiss(animated: true)
            }))
            
            self.present(alertController, animated: true)
        }
    }
    
    func checkHighScore() -> Bool {
        let prevHiScore = UserDefaults.standard.integer(forKey: Constants.hiScore)
        
        if prevHiScore < score {
            UserDefaults.standard.set(score, forKey: Constants.hiScore)
            UserDefaults.standard.synchronize()
            return true
        }
        return false
    }
    
    func checkAsteroidBonus() {
        let chance = Float.random(in: 0 ... 1)
        // Shield
        if chance > 0.7 && chance < 0.9 {
            updateShield(increment: Constants.shieldBonusIncrement)
            DispatchQueue.main.async {
                SoundEffect.sharedInstance.play(sound: .bonusShield)
            }
        // Proton Torpedoes
        } else if chance >= 0.9 {
            updateProtonTorpedoes(increment: Constants.protonTorpedoesBonusIncrement)
            DispatchQueue.main.async {
                SoundEffect.sharedInstance.play(sound: .bonusProtonTorpedoes)
            }
        }
    }
    
}
