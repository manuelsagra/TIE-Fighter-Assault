//
//  Laser.swift
//  Tie Fighter Assault
//
//  Created by Manuel Sagra de Diego on 23/03/2019.
//  Copyright © 2019 Manuel Sagra. All rights reserved.
//

import ARKit

class Shoot: SCNNode {
    
    // MARK: - Properties
    let velocity: Float = 9
    var type: Weapon
    var damage: Int = 0
    var force: SCNVector3 = SCNVector3Zero
    
    // MARK: - Initialization
    init(camera: ARCamera, type: Weapon) {
        self.type = type
        
        super.init()
        
        let shootGeometry: SCNGeometry
        switch type {
        case .Laser:
            shootGeometry = SCNSphere(radius: 0.1)
            let material = SCNMaterial()
            material.diffuse.contents = UIColor.red
            shootGeometry.materials = [material]
            damage = Constants.laserHitDamage
            
        case .ProtonTorpedoes:
            shootGeometry = SCNSphere(radius: 0.4)
            let material = SCNMaterial()
            material.diffuse.contents = UIColor.blue
            shootGeometry.materials = [material]
            damage = Constants.protonTorpedoDamage
        }
        geometry = shootGeometry
        
        let shape = SCNPhysicsShape(geometry: shootGeometry, options: nil)
        physicsBody = SCNPhysicsBody(type: .dynamic, shape: shape)
        physicsBody?.isAffectedByGravity = false
        
        physicsBody?.categoryBitMask = Collisions.shoot.rawValue
        physicsBody?.contactTestBitMask = Collisions.tie.rawValue | Collisions.asteroid.rawValue
        
        let matrix = SCNMatrix4(camera.transform)
        
        let v = -velocity
        force = SCNVector3(v * matrix.m31, v * matrix.m32, v * matrix.m33)
        let pos = SCNVector3(x: matrix.m41, y: matrix.m42, z: matrix.m43)
        
        self.position = pos
        resumeForce()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Stop and resume force
    func pauseForce() {
        self.physicsBody?.clearAllForces()
        self.physicsBody?.applyForce(SCNVector3Zero, asImpulse: true)
    }
    
    func resumeForce() {
        self.physicsBody?.applyForce(force, asImpulse: true)
    }
}
