//
//  TieFighter.swift
//  Tie Fighter Assault
//
//  Created by Manuel Sagra de Diego on 20/03/2019.
//  Copyright © 2019 Manuel Sagra. All rights reserved.
//

import SceneKit

class TieFighter: SCNNode {
    
    // MARK: - Properties
    private weak var game: GameViewController?
    var resistance = 0
    let initialResistance = Int.random(in: 10 ... 20)
    
    // MARK: - Initialization
    init(game: GameViewController) {
        self.game = game
        
        super.init()
        
        resistance = initialResistance
        
        physicsBody?.categoryBitMask = Collisions.tie.rawValue
        physicsBody?.contactTestBitMask = Collisions.shoot.rawValue
        
        loadModel(model: "TieFighter.scn")
        
        moveToPlayer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Movement
    private func moveToPlayer() {
        let move = SCNAction.move(to: SCNVector3(0, 0, 0), duration: TimeInterval(Float.random(in: 15.0 ... 20.0)))
        self.runAction(move) {
            self.game?.objectHit(object: self, damage: Constants.tieFighterHitDamage)
        }
    }
}
