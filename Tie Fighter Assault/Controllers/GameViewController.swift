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
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var protonTorpedoesLabel: UILabel!
    @IBOutlet weak var shieldLabel: UILabel!
    
    @IBOutlet weak var laserView: UIView!
    @IBOutlet weak var protonTorpedoesView: UIView!
    
    // MARK: - Properties
    var score: Int = 0
    var shield: Int = 100
    var protonTorpedoes: Int = 10
    var currentWeapon: Weapon = .Laser
    
    let arConfiguration = ARWorldTrackingConfiguration()
    
    var asteroidTimer = Timer()
    var tieFighter: SCNNode?
    
    var musicPlayer: MusicPlayer?
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Prevent Screen Off
        UIApplication.shared.isIdleTimerDisabled = true
        
        // AR Delegates
        sceneView.session.delegate = self
        sceneView.scene.physicsWorld.contactDelegate = self
        
        // Shoot
        let shootTap = UITapGestureRecognizer(target: self, action: #selector(tapScreen))
        sceneView.addGestureRecognizer(shootTap)
        
        // Change weapon
        let laserTap = UITapGestureRecognizer(target: self, action: #selector(tapLaser))
        laserView.addGestureRecognizer(laserTap)
        
        let protonTorpedoesTap = UITapGestureRecognizer(target: self, action: #selector(tapProtonTorpedoes))
        protonTorpedoesView.addGestureRecognizer(protonTorpedoesTap)
        
        // Music Player
        musicPlayer = MusicPlayer(with: "Game")
        musicPlayer?.play()
        
        // Init world
        asteroidTimer = Timer.scheduledTimer(timeInterval: Constants.asteroidSpawnTime, target: self, selector: #selector(addAsteroid), userInfo: nil, repeats: true)
        addTieFighter()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        resume()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        pause()
    }
}

