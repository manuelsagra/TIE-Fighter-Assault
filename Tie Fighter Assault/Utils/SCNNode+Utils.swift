//
//  3DObject.swift
//  Tie Fighter Assault
//
//  Created by Manuel Sagra de Diego on 20/03/2019.
//  Copyright © 2019 Manuel Sagra. All rights reserved.
//

import SceneKit

extension SCNNode {
    
    func loadModel(model: String) {
        guard let object = SCNScene(named: model) else { return }
        let wrapperNode = SCNNode()
        for child in object.rootNode.childNodes {
            child.geometry?.firstMaterial?.lightingModel = .phong
            wrapperNode.addChildNode(child)
        }
        self.addChildNode(wrapperNode)
        
        // Physics
        let shape = SCNPhysicsShape(node: wrapperNode, options: nil)
        physicsBody = SCNPhysicsBody(type: .static, shape: shape)
        physicsBody?.isAffectedByGravity = false
    }
    
    func face(to cameraOrientation: simd_float4x4) {
        var transform = cameraOrientation
        transform.columns.3.x = self.position.x
        transform.columns.3.y = self.position.y
        transform.columns.3.z = self.position.z
        
        self.transform = SCNMatrix4(transform)
    }
    
}
