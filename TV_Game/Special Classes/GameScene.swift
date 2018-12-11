//
//  GameScene.swift
//  Assignment2and3
//
//  Created by Xcode User on 2018-11-22.
//  Copyright © 2018 Xcode User. All rights reserved.
//

/*
 Created By Austin Peddle
 */

import SpriteKit
import GameplayKit

struct PhysicsCategory {
    static let None : UInt32 = 0
    static let All : UInt32 = UInt32.max
    static let Wall : UInt32 = 0b1
    static let Hero : UInt32 = 0b10
    static let End : UInt32 = 0b100
    static let Projectile : UInt32 = 0b11
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    private var shapeWall : SKShapeNode?
    private var shapeEnd : SKShapeNode?
    
    private var score : Int? = 10000
    private var lblScore : SKLabelNode?
    private var lblWinner : SKLabelNode?
    private var lblFinalScore : SKLabelNode?
    
    private var timer:Timer?
    
    override func didMove(to view: SKView) {
        
        // Get label node from scene and store it for use later
        self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
        if let label = self.label {
            label.alpha = 0.0
            label.run(SKAction.fadeIn(withDuration: 2.0))
        }
        
        // Create shape node to use during mouse interaction
        let w = (self.size.width + self.size.height) * 0.01
        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
        
        if let spinnyNode = self.spinnyNode {
            spinnyNode.lineWidth = 2.5
            
            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)))
            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
                                              SKAction.fadeOut(withDuration: 0.5),
                                              SKAction.removeFromParent()]))
        }
        
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self
        
        spinnyNode?.physicsBody = SKPhysicsBody(circleOfRadius: 0.5)
        spinnyNode?.physicsBody?.isDynamic = true
        spinnyNode?.physicsBody?.categoryBitMask = PhysicsCategory.Hero
        spinnyNode?.physicsBody?.contactTestBitMask = PhysicsCategory.Wall
        spinnyNode?.physicsBody?.collisionBitMask = PhysicsCategory.None
        
        self.shapeEnd = self.childNode(withName: "//EndGoal") as? SKShapeNode

        self.shapeEnd?.physicsBody = SKPhysicsBody(rectangleOf: (self.shapeEnd?.frame.size)!)
        self.shapeEnd?.physicsBody?.isDynamic = false
        self.shapeEnd?.physicsBody?.categoryBitMask = PhysicsCategory.End
        self.shapeEnd?.physicsBody?.contactTestBitMask = PhysicsCategory.Hero
        self.shapeEnd?.physicsBody?.collisionBitMask = PhysicsCategory.None
        
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
        
        timerSet()
        
    }
    
    func timerSet()
    {
        score = 10000
        
        self.lblScore = self.childNode(withName: "//Score") as! SKLabelNode
        self.lblScore?.text = "Score:  \(score!)"
        
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
    
    func didBegin(_ contact: SKPhysicsContact) {
        var firstBody: SKPhysicsBody
        var secondBody : SKPhysicsBody
        
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
        
        if((firstBody.categoryBitMask & PhysicsCategory.Wall != 0) && (secondBody.categoryBitMask & PhysicsCategory.Hero != 0))
        {
            heroDidCollideWithWall()
        }
        
        if((firstBody.categoryBitMask & PhysicsCategory.Hero != 0) || (secondBody.categoryBitMask & PhysicsCategory.End != 0))
        {
            heroDidCollideWithEnd()
        }
    }
    
    func delay(_ delay:Double, closure:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }
    
    func heroDidCollideWithEnd()
    {
        timer?.invalidate()
        
        self.lblWinner = self.childNode(withName: "//Winner") as! SKLabelNode
        self.lblWinner?.text = "Winner"
        self.lblFinalScore = self.childNode(withName: "//FinalScore") as! SKLabelNode
        self.lblFinalScore?.text = "Score:  \(self.score!)"
        
        self.lblScore?.text = ""
        
        print("End")
    }
    
    func heroDidCollideWithWall()
    {
        timer?.invalidate()
        touchUp(atPoint: CGPoint(x: 0.5, y: 0.5))
        timerSet()
        UIApplication.shared.beginIgnoringInteractionEvents()
        print("Hit")
    }
    
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
    
    func touchMoved(toPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.blue
            self.addChild(n)
        }
    }
    
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
