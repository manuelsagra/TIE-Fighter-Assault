//
//  GameUI.swift
//  Tie Fighter Assault
//
//  Created by Manuel Sagra de Diego on 23/03/2019.
//  Copyright © 2019 Manuel Sagra. All rights reserved.
//

import UIKit

extension GameViewController {
    
    func updateWeaponUI() {
        switch currentWeapon {
        case .Laser:
            laserView.alpha = 1
            protonTorpedoesView.alpha = 0.5
            
        case .ProtonTorpedoes:
            laserView.alpha = 0.5
            protonTorpedoesView.alpha = 1
        }
    }
    
    func updateProtonTorpedoes(increment: Int) {
        protonTorpedoes += increment
        if protonTorpedoes > 99 {
            protonTorpedoes = 99
        } else if protonTorpedoes == 0 {
            currentWeapon = .Laser
            updateWeaponUI()
        }
        DispatchQueue.main.async {
            self.protonTorpedoesLabel.text = String(format: "%02d", self.protonTorpedoes)
        }
    }
    
    func updateScore(increment: Int) {
        score += increment
        DispatchQueue.main.async {
            self.scoreLabel.text = String(format: "%08d", self.score)
        }
    }
    
    func updateShield(increment: Int) {
        shield += increment
        if shield <= 0 {
            gameOver()
            shield = 0
        }
        DispatchQueue.main.async {
            self.shieldLabel.text = "\(String(format: "%02d", self.shield))%"
        }
    }
}
