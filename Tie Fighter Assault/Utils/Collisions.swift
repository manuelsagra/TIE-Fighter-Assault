//
//  Collisions.swift
//  Tie Fighter Assault
//
//  Created by Manuel Sagra de Diego on 23/03/2019.
//  Copyright © 2019 Manuel Sagra. All rights reserved.
//

import Foundation

struct Collisions: OptionSet {
    let rawValue: Int
    
    static let tie = Collisions(rawValue: 1)
    static let asteroid = Collisions(rawValue: 2)
    static let shoot = Collisions(rawValue: 4)
}
