//
//  Constants.swift
//  Tie Fighter Assault
//
//  Created by Manuel Sagra de Diego on 20/03/2019.
//  Copyright © 2019 Manuel Sagra. All rights reserved.
//

import Foundation

enum Constants {
    // Properties
    static let hiScore = "High Score"
    
    // Eject
    static let ejectTitle = "Are you sure?"
    static let ejectMessage = "The rebel alliance needs you!\n\nIf you leave it will be GAME OVER for you... and the galaxy."
    
    // Game Over
    static let gameOverTitle = "Game Over!"
    static let gameOverMessage = "See you again rebel pilot!"
    
    // Damage
    static let asteroidHitDamage = -20
    static let tieFighterHitDamage = -50
    
    // Timer
    static let asteroidSpawnTime: Double = 10.0 // Seconds
}

typealias AnimationCompletion = (() -> Void)
