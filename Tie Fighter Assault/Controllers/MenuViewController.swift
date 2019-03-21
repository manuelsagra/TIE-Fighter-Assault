//
//  MenuViewController.swift
//  Tie Fighter Assault
//
//  Created by Manuel Sagra de Diego on 20/03/2019.
//  Copyright © 2019 Manuel Sagra. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
  
    // MARK: - Outlets
    @IBOutlet weak var hiScoreLabel: UILabel!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Print high score
        let hiScore = UserDefaults.standard.integer(forKey: Constants.hiScore)
        hiScoreLabel.text = String(format: "%08d", hiScore)
    }
    
    // MARK: - Events
    @IBAction func gameStartClicked(_ sender: Any) {
        self.present(GameViewController(), animated: false)
    }
    
}
