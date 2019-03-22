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
    private var protonTorpedoes: Int = 10
    private var currentWeapon: Weapon = .Laser
    private let arConfiguration = ARWorldTrackingConfiguration()
    private var asteroidTimer = Timer()
    
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
        asteroidTimer = Timer.scheduledTimer(timeInterval: Constants.asteroidSpawnTime, target: self, selector: #selector(addAsteroid), userInfo: nil, repeats: true)
        addTieFighter()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        sceneView.session.run(arConfiguration)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        pause()
    }
}

// MARK: - Objects management
extension GameViewController {
    
    func addTieFighter() {
        let tie = TieFighterVader()
        tie.position.x = Float.random(in: -1 ... 1)
        tie.position.y = Float.random(in: -1 ... 1)
        tie.position.z = Float.random(in: -50 ... -30)
        
        sceneView.scene.rootNode.addChildNode(tie)
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
        print("\(nodes.count) nodes")
        nodes.forEach { childNode in
            if childNode == node {
                print("Node found!")
                childNode.removeFromParentNode()
            }
        }
    }
}

// MARK: - Tap Events
extension GameViewController {

    @IBAction func ejectClicked(_ sender: Any) {
        pause()
        
        let alertController = UIAlertController(title: Constants.ejectTitle, message: Constants.ejectMessage, preferredStyle: .alert)
        let ejectAction = UIAlertAction(title: "Eject", style: .default) { (_) -> Void in
            self.gameOver()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alertController.addAction(cancelAction)
        alertController.addAction(ejectAction)
        
        self.present(alertController, animated: true, completion: {
            self.resume()
        })
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
}

// MARK: - Game events / status
extension GameViewController {
    private func pause() {
        sceneView.session.pause()
        asteroidTimer.invalidate()
    }
    
    private func resume() {
        sceneView.session.run(arConfiguration)
        asteroidTimer.fire()
    }
    
    func asteroidHit(asteroid: SCNNode) {
        // TODO Sound
        // TODO Check Bonus (Shield, protons)
        updateShield(increment: Constants.asteroidHitDamage)
        removeNode(asteroid)
    }
    
    private func gameOver() {
        pause()
        
        var message = Constants.gameOverMessage
        if checkHighScore() {
            message = "\(message)\n\nNew high score, congratulations!"
        }
        let alertController = UIAlertController(title: Constants.gameOverTitle, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Accept", style: .default, handler: { (_) -> Void in
            self.pause()
            self.dismiss(animated: true)
        }))
        
        self.present(alertController, animated: true)
    }
    
    private func checkHighScore() -> Bool {
        let prevHiScore = UserDefaults.standard.integer(forKey: Constants.hiScore)
        
        if prevHiScore < score {
            UserDefaults.standard.set(score, forKey: Constants.hiScore)
            UserDefaults.standard.synchronize()
            return true
        }
        return false
    }
}

// MARK: - Game UI
extension GameViewController {
    
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
        DispatchQueue.main.async {
            self.protonTorpedoesLabel.text = String(format: "%02d", self.protonTorpedoes)
        }
    }
    
    private func updateScore(increment: Int) {
        score += increment
        DispatchQueue.main.async {
            self.scoreLabel.text = String(format: "%08d", self.score)
        }
    }
    
    private func updateShield(increment: Int) {
        shield += increment
        if shield <= 0 {
            gameOver()
            shield = 0
        }
        DispatchQueue.main.async {
            self.shieldLabel.text = "\(String(format: "%02d", self.shield))%"
        }
    }
}

extension GameViewController: SCNPhysicsContactDelegate {

}

extension GameViewController: ARSCNViewDelegate {
    
}
