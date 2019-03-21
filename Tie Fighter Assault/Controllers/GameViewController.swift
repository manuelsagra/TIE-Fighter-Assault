//
//  GameViewController.swift
//  Tie Fighter Assault
//
//  Created by Manuel Sagra de Diego on 20/03/2019.
//  Copyright © 2019 Manuel Sagra. All rights reserved.
//

import ARKit

enum Weapon {
    case Laser
    case ProtonTorpedoes
}

class GameViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var protonTorpedoesLabel: UILabel!
    @IBOutlet weak var shieldLabel: UILabel!
    
    @IBOutlet weak var laserView: UIView!
    @IBOutlet weak var protonTorpedoesView: UIView!
    
    // MARK: - Properties
    private var score: Int = 0
    private var shield: Int = 100
    private var protonTorpedoes: Int = 0
    private var currentWeapon: Weapon = .Laser
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Prevent Screen Off
        UIApplication.shared.isIdleTimerDisabled = true
        
        // AR Delegates
        sceneView.delegate = self
        sceneView.scene.physicsWorld.contactDelegate = self
        
        // Shoot
        let shootTap = UITapGestureRecognizer(target: self, action: #selector(tapScreen))
        sceneView.addGestureRecognizer(shootTap)
        
        // Change weapon
        let laserTap = UITapGestureRecognizer(target: self, action: #selector(tapLaser))
        laserView.addGestureRecognizer(laserTap)
        
        let protonTorpedoesTap = UITapGestureRecognizer(target: self, action: #selector(tapProtonTorpedoes))
        protonTorpedoesView.addGestureRecognizer(protonTorpedoesTap)
        
        // Init world
        addTieFighter()
        addAsteroids()
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
    
    // MARK: - Objects
    func addTieFighter() {
        let tie = TieFighterVader()
        tie.position.x = Float.random(in: -1 ... 1)
        tie.position.y = Float.random(in: -1 ... 1)
        tie.position.z = Float.random(in: -50 ... -30)
        
        sceneView.scene.rootNode.addChildNode(tie)
    }
    
    func addAsteroids() {
        for _ in 1...10 {
            let asteroid = Asteroid()
            asteroid.position.x = Float.random(in: -10 ... 10)
            asteroid.position.y = Float.random(in: -1 ... 1)
            asteroid.position.z = Float.random(in: -5 ... -3)
            
            sceneView.scene.rootNode.addChildNode(asteroid)
        }
    }
    
    // MARK: - Events
    @IBAction func ejectClicked(_ sender: Any) {
        let alertController = UIAlertController(title: Constants.ejectTitle, message: Constants.ejectMessage, preferredStyle: .alert)
        let settingsAction = UIAlertAction(title: "Eject", style: .default) { (_) -> Void in
            self.dismiss(animated: false)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alertController.addAction(cancelAction)
        alertController.addAction(settingsAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc private func tapScreen() {
        updateScore(increment: 10)
        
        if currentWeapon == .ProtonTorpedoes {
            updateProtonTorpedoes(increment: -1)
        }
        
        // TODO Shoot
    }
    
    @objc private func tapLaser() {
        currentWeapon = .Laser
        updateWeaponUI()
    }
    
    @objc private func tapProtonTorpedoes() {
        if protonTorpedoes > 0 {
            currentWeapon = .ProtonTorpedoes
            updateWeaponUI()
        }
    }
    
    // MARK: - Game UI
    private func updateWeaponUI() {
        switch currentWeapon {
        case .Laser:
            laserView.alpha = 1
            protonTorpedoesView.alpha = 0.5
            
        case .ProtonTorpedoes:
            laserView.alpha = 0.5
            protonTorpedoesView.alpha = 1
        }
    }
    
    private func updateProtonTorpedoes(increment: Int) {
        protonTorpedoes += increment
        if protonTorpedoes > 99 {
            protonTorpedoes = 99
        } else if protonTorpedoes == 0 {
            currentWeapon = .Laser
            updateWeaponUI()
        }
        protonTorpedoesLabel.text = String(format: "%02d", protonTorpedoes)
    }
    
    private func updateScore(increment: Int) {
        score += increment
        scoreLabel.text = String(format: "%08d", score)
    }
}

extension GameViewController: SCNPhysicsContactDelegate {

}

extension GameViewController: ARSCNViewDelegate {
    
}
