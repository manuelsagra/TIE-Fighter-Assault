//
//  Asteroid.swift
//  Tie Fighter Assault
//
//  Created by Manuel Sagra de Diego on 20/03/2019.
//  Copyright © 2019 Manuel Sagra. All rights reserved.
//

import SceneKit

class Asteroid: Object3D {
    
    // MARK: - Properties
    private weak var game: GameViewController?
    
    // MARK: - Initialization
    init(game: GameViewController?) {
        self.game = game
        
        super.init()
        
        loadModel(model: "Asteroid.dae")
        
        rotate()
        moveToPlayer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Movement
    private func rotate() {
        let rotateOne = SCNAction.rotateBy(x: CGFloat(Float.pi), y: 0, z: 0, duration: 4.0)
        let repeatForever = SCNAction.repeatForever(rotateOne)
        self.runAction(repeatForever)
    }
    
    private func moveToPlayer() {
        let move = SCNAction.move(to: SCNVector3(0, 0, 0), duration: TimeInterval(Float.random(in: 10.0 ... 15.0)))
        self.runAction(move) {
            self.game?.asteroidHit(asteroid: self)
        }
    }
}
