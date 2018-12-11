//
//  GameScene.swift
//  Assignment2and3
//
//  Created by Xcode User on 2018-11-22.
//  Copyright © 2018 Xcode User. All rights reserved.
//

/*
 Created By Austin Peddle
 
 Creates game specific mechanics, such as collision detection, score updating, and generation of playerNode.
 */

import SpriteKit
import GameplayKit

//Represents all of the physical components the player can interact with
struct PhysicsCategory {
    static let None : UInt32 = 0
    static let All : UInt32 = UInt32.max
    static let Wall : UInt32 = 0b1
    static let Hero : UInt32 = 0b10
    static let End : UInt32 = 0b100
    static let Projectile : UInt32 = 0b11
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    //Label in gamescene
    private var label : SKLabelNode?
    //Represents the player model
    private var spinnyNode : SKShapeNode?
    
    //Represents the walls that exist in the maze
    private var shapeWall : SKShapeNode?
    private var shapeEnd : SKShapeNode?
    
    //Tracks player score
    private var score : Int? = 10000
    //Makes player score visible
    private var lblScore : SKLabelNode?
    //Shows label if player wins
    private var lblWinner : SKLabelNode?
    //Shows label of score if player wins
    private var lblFinalScore : SKLabelNode?
    
    //Timer used to count down total score
    private var timer:Timer?
    
    //Tracks the players movements to create trailing effect/sees if they collide into objects
    override func didMove(to view: SKView) {
        
        // Get label node from scene and store it for use later
        self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
        if let label = self.label {
            label.alpha = 0.0
            label.run(SKAction.fadeIn(withDuration: 2.0))
        }
        
        // size of player
        let w = (self.size.width + self.size.height) * 0.01
        // create player node
        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
        
        // spin player node and create trailing effect
        if let spinnyNode = self.spinnyNode {
            spinnyNode.lineWidth = 2.5
            
            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)))
            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
                                              SKAction.fadeOut(withDuration: 0.5),
                                              SKAction.removeFromParent()]))
        }
        
        // Add physics to gamescene
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self
        
        //Associate physics with player node
        spinnyNode?.physicsBody = SKPhysicsBody(circleOfRadius: 0.5)
        spinnyNode?.physicsBody?.isDynamic = true
        spinnyNode?.physicsBody?.categoryBitMask = PhysicsCategory.Hero
        spinnyNode?.physicsBody?.contactTestBitMask = PhysicsCategory.Wall
        spinnyNode?.physicsBody?.collisionBitMask = PhysicsCategory.None
        
        //Associate physics with end goal
        self.shapeEnd = self.childNode(withName: "//EndGoal") as? SKShapeNode
        self.shapeEnd?.physicsBody = SKPhysicsBody(rectangleOf: (self.shapeEnd?.frame.size)!)
        self.shapeEnd?.physicsBody?.isDynamic = false
        self.shapeEnd?.physicsBody?.categoryBitMask = PhysicsCategory.End
        self.shapeEnd?.physicsBody?.contactTestBitMask = PhysicsCategory.Hero
        self.shapeEnd?.physicsBody?.collisionBitMask = PhysicsCategory.None
        
        //loop through and add physics to all 14 walls
       for i in 1...14
        {
            self.shapeWall = self.childNode(withName: "//Wall" + String(i)) as? SKShapeNode
            
            if(i <= 11)
            {
                self.shapeWall?.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: (self.shapeWall?.frame.size.width)!, height: (self.shapeWall?.frame.size.height)!))
                self.shapeWall?.physicsBody?.isDynamic = false
                self.shapeWall?.physicsBody?.categoryBitMask = PhysicsCategory.Wall
                self.shapeWall?.physicsBody?.contactTestBitMask = PhysicsCategory.Hero
                self.shapeWall?.physicsBody?.collisionBitMask = PhysicsCategory.None
            }
            else
            {
                self.shapeWall?.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: (self.shapeWall?.frame.size.height)!, height: (self.shapeWall?.frame.size.width)!))
                self.shapeWall?.physicsBody?.isDynamic = false
                self.shapeWall?.physicsBody?.categoryBitMask = PhysicsCategory.Wall
                self.shapeWall?.physicsBody?.contactTestBitMask = PhysicsCategory.Hero
                self.shapeWall?.physicsBody?.collisionBitMask = PhysicsCategory.None
            }
        }
        
        //set score timer to 10000
        timerSet()
        
    }
    
    //Used to set the total score and count down using timer
    func timerSet()
    {
        //initial score
        score = 10000
        
        //Updated score label
        self.lblScore = self.childNode(withName: "//Score") as! SKLabelNode
        self.lblScore?.text = "Score:  \(score!)"
        
        //update score label as timer counts down; If collision occurs stop timer
        self.timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { timer in
            self.score = self.score!-1
            self.lblScore = self.childNode(withName: "//Score") as! SKLabelNode
            self.lblScore?.text = "Score:  \(self.score!)"

            if (UIApplication.shared.isIgnoringInteractionEvents && self.score == 9990)
            {
                UIApplication.shared.endIgnoringInteractionEvents()
            }
            
            if self.score == 0 {
                self.heroDidCollideWithWall()
            }
        }
    }
    
    // Method to see if collision occurs
    func didBegin(_ contact: SKPhysicsContact) {
        var firstBody: SKPhysicsBody
        var secondBody : SKPhysicsBody
        
        // Checks to see if contact occurs between bodies
        if(contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask)
        {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        }
        else
        {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        //if contact occurs with a wall the player loses
        if((firstBody.categoryBitMask & PhysicsCategory.Wall != 0) && (secondBody.categoryBitMask & PhysicsCategory.Hero != 0))
        {
            heroDidCollideWithWall()
        }
        
        //if contact occurs with the end goal player wins
        if((firstBody.categoryBitMask & PhysicsCategory.Hero != 0) || (secondBody.categoryBitMask & PhysicsCategory.End != 0))
        {
            heroDidCollideWithEnd()
        }
    }
    
    func delay(_ delay:Double, closure:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }
    
    // Method to indicate that the player has beat the game
    func heroDidCollideWithEnd()
    {
        //Stop score from being reduced
        timer?.invalidate()
        
        //Populate winner label
        self.lblWinner = self.childNode(withName: "//Winner") as! SKLabelNode
        self.lblWinner?.text = "Winner"
        
        //Populate score label
        self.lblFinalScore = self.childNode(withName: "//FinalScore") as! SKLabelNode
        self.lblFinalScore?.text = "Score:  \(self.score!)"
        
        self.lblScore?.text = ""
        
        print("End")
    }
    
    // Method to restart the game if you hit a wall
    func heroDidCollideWithWall()
    {
        //stop score
        timer?.invalidate()
        
        //Make player node red
        touchUp(atPoint: CGPoint(x: 0.5, y: 0.5))
        
        //start timer over again
        timerSet()
        
        //ignore player touches to prevent cheating
        UIApplication.shared.beginIgnoringInteractionEvents()
        print("Hit")
    }
    
    // Colour player node when first touched and remove winner/score labels from on top
    func touchDown(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.green
            self.addChild(n)
            self.lblWinner = self.childNode(withName: "//Winner") as! SKLabelNode
            self.lblWinner?.text = ""
            self.lblFinalScore = self.childNode(withName: "//FinalScore") as! SKLabelNode
            self.lblFinalScore?.text = ""
        }
    }
    
    // Track and colour player node
    func touchMoved(toPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.blue
            self.addChild(n)
        }
    }
    
    //Stop ignoring touch on player to restart
    func touchUp(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.red
            self.addChild(n)
            UIApplication.shared.endIgnoringInteractionEvents()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let label = self.label {
            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
        }
        
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
