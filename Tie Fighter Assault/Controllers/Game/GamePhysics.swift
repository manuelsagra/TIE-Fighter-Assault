//
//  GamePhysics.swift
//  Tie Fighter Assault
//
//  Created by Manuel Sagra de Diego on 23/03/2019.
//  Copyright © 2019 Manuel Sagra. All rights reserved.
//

import ARKit

// MARK: Object hits
extension GameViewController {
    
    func objectHit(object: SCNNode, damage: Int) {
        DispatchQueue.main.async {
            SoundEffect.sharedInstance.play(sound: .playerHit)
        
            self.updateShield(increment: -damage)
            self.removeNode(object)
            if object is TieFighter {
                self.addTieFighter()
            }
        }
    }
    
}

// MARK: - Billboard
extension GameViewController: ARSessionDelegate {
    
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        guard
            let cameraOrientation = sceneView.pointOfView?.transform,
            let tie = tieFighter else {
                return
            }
        tie.face(to: matrix_float4x4(cameraOrientation))
    }
    
}

// MARK: - Shoot hits
extension GameViewController: SCNPhysicsContactDelegate {
    
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        let c1 = contact.nodeA
        let c2 = contact.nodeB
        
        // Asteroid hit by shoot
        if c1 is Asteroid && c2 is Shoot ||
            c2 is Asteroid && c1 is Shoot {
            let asteroid: Asteroid = c1 is Asteroid ? c1 as! Asteroid : c2 as! Asteroid
            let shoot: Shoot = c1 is Shoot ? c1 as! Shoot : c2 as! Shoot
            
            asteroid.resistance -= shoot.damage
            
            if asteroid.resistance <= 0 {
                removeNode(asteroid)
                updateScore(increment: Constants.asteroidScore)
                DispatchQueue.main.async {
                    SoundEffect.sharedInstance.play(sound: .asteroidExplosion)
                }
                checkAsteroidBonus()
                Explosion.showExplosion(with: asteroid, in: sceneView.scene)
            } else {
                DispatchQueue.main.async {
                    SoundEffect.sharedInstance.play(sound: .hit)
                }
            }
            
            removeNode(shoot)
        }
        
        // Tie Fighter hit by shoot
        if c1 is TieFighter && c2 is Shoot ||
            c2 is TieFighter && c1 is Shoot {
            let tie: TieFighter = c1 is TieFighter ? c1 as! TieFighter : c2 as! TieFighter
            let shoot: Shoot = c1 is Shoot ? c1 as! Shoot : c2 as! Shoot
            
            tie.receiveDamage(damage: shoot.damage)
            
            if tie.resistance <= 0 {
                removeNode(tie)
                updateScore(increment: Constants.tieFighterScore)
                DispatchQueue.main.async {
                    SoundEffect.sharedInstance.play(sound: .tieFighterExplosion)
                    self.addTieFighter()
                }
                Explosion.showExplosion(with: tie, in: sceneView.scene)
                
                // Remove other shoots to prevent perfomance degradation
                let nodes = sceneView.scene.rootNode.childNodes
                nodes.forEach { node in
                    if node is Shoot {
                        node.removeFromParentNode()
                    }
                }
            } else {
                DispatchQueue.main.async {
                    SoundEffect.sharedInstance.play(sound: .hit)
                }
            }
            
            removeNode(shoot)
        }
    }
    
}
