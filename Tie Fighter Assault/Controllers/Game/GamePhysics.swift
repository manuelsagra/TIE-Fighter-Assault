//
//  GamePhysics.swift
//  Tie Fighter Assault
//
//  Created by Manuel Sagra de Diego on 23/03/2019.
//  Copyright © 2019 Manuel Sagra. All rights reserved.
//

import ARKit

// MARK: Hits
extension GameViewController {
    func asteroidHit(asteroid: SCNNode) {
        // TODO Sound
        updateShield(increment: -Constants.asteroidHitDamage)
        removeNode(asteroid)
    }
}

// MARK: - Billboard
extension GameViewController: SCNPhysicsContactDelegate {
    
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        let cameraOrientation = session.currentFrame?.camera.transform
        tieFighter?.face(to: cameraOrientation!)
    }
    
}

// MARK: - Shoot hits
extension GameViewController: ARSCNViewDelegate {
    
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        let c1 = contact.nodeA
        let c2 = contact.nodeB
        
        // Asteroid hit by shoot
        if c1.physicsBody?.categoryBitMask == Collisions.asteroid.rawValue && c2.physicsBody?.categoryBitMask == Collisions.shoot.rawValue ||
            c2.physicsBody?.categoryBitMask == Collisions.asteroid.rawValue && c1.physicsBody?.categoryBitMask == Collisions.shoot.rawValue{
            let asteroid: Asteroid = c1 is Asteroid ? c1 as! Asteroid : c2 as! Asteroid
            let shoot: Shoot = c1 is Shoot ? c1 as! Shoot : c2 as! Shoot
            
            asteroid.resistance -= shoot.damage
            
            if asteroid.resistance <= 0 {
                removeNode(asteroid)
                updateScore(increment: Constants.asteroidScore)
                DispatchQueue.main.async {
                    SoundEffect.sharedInstance.play(sound: .asteroidExplossion)
                }
                // TODO Explosion effect
                // TODO Bonus (Shield / Torpedo)
            } else {
                DispatchQueue.main.async {
                    SoundEffect.sharedInstance.play(sound: .hit)
                }
            }
            
            removeNode(shoot)
        }
        
        // TODO Tie Fighter hit by shoot
    }
    
}
