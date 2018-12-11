//
//  GameViewController.swift
//  Assignment2and3
//
//  Created by Xcode User on 2018-11-22.
//  Copyright © 2018 Xcode User. All rights reserved.
//

/*
 Created by Austin Peddle
 
 Loads Game into scene
 */

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Get scene view
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }

}
