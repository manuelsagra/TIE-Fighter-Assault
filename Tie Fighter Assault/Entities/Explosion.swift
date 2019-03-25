//
//  Explosion.swift
//  Tie Fighter Assault
//
//  Created by Manuel Sagra de Diego on 24/03/2019.
//  Copyright © 2019 Manuel Sagra. All rights reserved.
//

import ARKit

struct Explosion {
    
    static func showExplosion(with node: SCNNode, in scene: SCNScene) {
        show(with: node, in: scene, by: "Explosion")
    }
    
    private static func show(with node: SCNNode, in scene: SCNScene, by name: String) {
        guard let explosion = SCNParticleSystem(named: name, inDirectory: nil) else { return }
        
        var transform = node.transform
        
        var multiplier: Float = 1
        if node is Asteroid {
            multiplier = 6
        } else if node is TieFighter {
            multiplier = 2
        }
        
        transform.m41 *= multiplier
        transform.m42 *= multiplier
        transform.m43 *= multiplier
        
        scene.addParticleSystem(explosion, transform: transform)
    }
    
}
