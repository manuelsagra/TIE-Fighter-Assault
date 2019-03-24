//
//  GameObjects.swift
//  Tie Fighter Assault
//
//  Created by Manuel Sagra de Diego on 23/03/2019.
//  Copyright © 2019 Manuel Sagra. All rights reserved.
//

import ARKit

// MARK: - Objects management
extension GameViewController {
    
    func addTieFighter() {
        tieFighter = TieFighter(game: self)
        tieFighter?.position.x = Float.random(in: -20 ... 20)
        tieFighter?.position.y = Float.random(in: -1 ... 1)
        tieFighter?.position.z = Float.random(in: -50 ... -30)
        
        sceneView.scene.rootNode.addChildNode(tieFighter!)
        
        DispatchQueue.main.async {
            SoundEffect.sharedInstance.play(sound: .tieFighterFlyby)
        }
    }
    
    @objc func addAsteroid() {
        let asteroid = Asteroid(game: self)
        asteroid.position.x = Float.random(in: -10 ... 10)
        asteroid.position.y = Float.random(in: -1 ... 1)
        asteroid.position.z = Float.random(in: -20 ... -10)
        
        sceneView.scene.rootNode.addChildNode(asteroid)
    }
    
    func removeNode(_ node: SCNNode) {
        let nodes = sceneView.scene.rootNode.childNodes
        nodes.forEach { childNode in
            if childNode == node {
                childNode.removeFromParentNode()
            }
        }
    }
    
}
