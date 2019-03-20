//
//  GameViewController.swift
//  Tie Fighter Assault
//
//  Created by Manuel Sagra de Diego on 20/03/2019.
//  Copyright © 2019 Manuel Sagra. All rights reserved.
//

import ARKit

class GameViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var sceneView: ARSCNView!
    
    // MARK: - Properties    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // AR Delegates
        sceneView.delegate = self
        sceneView.scene.physicsWorld.contactDelegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sceneView.session.pause()
    }

}

extension GameViewController: SCNPhysicsContactDelegate {

}

extension GameViewController: ARSCNViewDelegate {
    
}
