//
//  TieFighter.swift
//  Tie Fighter Assault
//
//  Created by Manuel Sagra de Diego on 20/03/2019.
//  Copyright © 2019 Manuel Sagra. All rights reserved.
//

import SceneKit

class TieFighter: SCNNode {
    
    // MARK: - Initialization
    override init() {
        super.init()
        
        loadModel(model: "TieFighter.dae")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
