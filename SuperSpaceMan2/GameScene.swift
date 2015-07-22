//
//  GameScene.swift
//  SuperSpaceMan2
//
//  Created by Adam Johnson on 6/15/15.
//  Copyright (c) 2015 Adam. All rights reserved.
//

import SpriteKit
import CoreMotion

class GameScene: SKScene, SKPhysicsContactDelegate
{
    var backgroundNode : SKSpriteNode?
    var backgroundStarsNode : SKSpriteNode?
    var backgroundPlanetNode : SKSpriteNode?
    var playerNode : SKSpriteNode?

    var coreMotionManager = CMMotionManager()
    var xAxisAcceleration : CGFloat = 0

    var foregroundNode : SKSpriteNode?

    let CollisionCategoryPlayer : UInt32 = 0x1 << 1
    let CollisionCategoryPowerUpOrbs : UInt32 = 0x1 << 2
    let CollisionCategoryBlackHoles : UInt32 = 0x1 << 3
    let CollisionCategoryBlueLaser : UInt32 = 0x1 << 4

    var engineExhaust : SKEmitterNode?
    var exhaustTime : NSTimer?

    var impulseCount = 20
    var score = 0
    let scoreTextNode = SKLabelNode(fontNamed: "Copperplate")

    var impulseTextNode = SKLabelNode(fontNamed: "Copperplate")

    var orbPopAction = SKAction.playSoundFileNamed("orb_pop.wav", waitForCompletion: false)


    let startGameTextNode = SKLabelNode(fontNamed: "Copperplate")


    var music = SKAction.playSoundFileNamed("gamemusic2.wav", waitForCompletion: false)




    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }


    override init(size: CGSize)
    {
        super.init(size: size)

        // Sets the delegate.
        physicsWorld.contactDelegate = self

        // Sets the strength of gravity.
        physicsWorld.gravity = CGVectorMake(0.0, -5.0)


        // Turns on user interaction.
        userInteractionEnabled = true

        // The background node must come before the foreground node.
        addBackground()
      
        // UNCOMMENT IF NEEDED
        addStarsBackground()

        //addPlanetBackground()

        addForeground()

        addPlayerToForeground()

        addOrbsToForeground()

        addBadGuys()

        addScoreLabel()

        addImpulseLabel()

        addEngineExhaust()

        addStartGameLabel()

        runAction(music)
    }





    func addStartGameLabel()
    {
        startGameTextNode.text = "TAP ANYWHERE TO START!"
        startGameTextNode.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        startGameTextNode.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        startGameTextNode.fontSize = 20
        startGameTextNode.fontColor = SKColor.whiteColor()
        startGameTextNode.position = CGPointMake(scene!.size.width / 2, scene!.size.height / 2)

        addChild(startGameTextNode)
    }


    func addEngineExhaust()
    {
        let engineExhaustPath = NSBundle.mainBundle().pathForResource("EngineExhaust", ofType: "sks")
        engineExhaust = NSKeyedUnarchiver.unarchiveObjectWithFile(engineExhaustPath!) as? SKEmitterNode
        engineExhaust!.position = CGPointMake(0.0, -(playerNode!.size.height / 2))

        playerNode!.addChild(engineExhaust!)
        engineExhaust!.hidden = true;
    }


    func addScoreLabel()
    {
        scoreTextNode.text = "SCORE : \(score)"
        scoreTextNode.fontSize = 20
        scoreTextNode.fontColor = SKColor.whiteColor()
        scoreTextNode.position = CGPointMake(size.width - 10, size.height - 20)
        scoreTextNode.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Right

        addChild(scoreTextNode)
    }


    func addImpulseLabel()
    {
        impulseTextNode.text = "IMPULSES : \(impulseCount)"
        impulseTextNode.fontSize = 20
        impulseTextNode.fontColor = SKColor.whiteColor()
        impulseTextNode.position = CGPointMake(10.0, size.height - 20)
        impulseTextNode.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left

        addChild(impulseTextNode)
    }

    
    func addBackground()
    {
        // Sets background color behind image to black.
        backgroundColor = SKColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)

        // Adds the background picture.
        backgroundNode = SKSpriteNode(imageNamed: "Background")
        backgroundNode!.size.width = self.frame.size.width
        

        // Sets the background's anchor point.
        backgroundNode!.anchorPoint = CGPoint(x: 0.5, y: 0.0)

        // Sets the background's position.
        backgroundNode!.position = CGPoint(x: size.width / 2.0, y: 0.0)

        // Adds the background node.
        addChild(backgroundNode!)
    }


    // UNCOMMENT IF NEEDED
    func addStarsBackground()
    {
        backgroundStarsNode = SKSpriteNode(imageNamed: "Stars")
        backgroundStarsNode!.size.width = self.frame.size.width
        backgroundStarsNode!.anchorPoint = CGPoint(x: 0.5, y: 0.0)
        backgroundStarsNode!.position = CGPoint(x: size.width / 2.0, y: 0)

        addChild(backgroundStarsNode!)
    }


    func addPlanetBackground()
    {
        backgroundPlanetNode = SKSpriteNode(imageNamed: "PlanetStart")
        backgroundPlanetNode!.size.width = self.frame.size.width
        backgroundPlanetNode!.anchorPoint = CGPoint(x: 0.5, y: 0.0)
        backgroundPlanetNode!.position = CGPoint(x: size.width / 2.0, y: 0)

        addChild(backgroundPlanetNode!)
    }


    func addForeground()
    {
        foregroundNode = SKSpriteNode()

        addChild(foregroundNode!)
    }


    func addPlayerToForeground()
    {
        // Add the player.
        playerNode = SKSpriteNode(imageNamed: "blueship")

        // Add physics body to playerNode.
        playerNode!.physicsBody = SKPhysicsBody(circleOfRadius: playerNode!.size.width / 2)
        playerNode!.physicsBody!.dynamic = false

        // Set player position.
        playerNode!.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        playerNode!.position = CGPoint(x: self.size.width / 2.0, y: 220.0)

        // Add simulated air friction.
        playerNode!.physicsBody!.linearDamping = 1.0

        // Turns off rotation when collided with.
        playerNode!.physicsBody!.allowsRotation = false

        // Setting up the bit masks for playerNode.
        playerNode!.physicsBody!.categoryBitMask = CollisionCategoryPlayer
        playerNode!.physicsBody!.contactTestBitMask = CollisionCategoryPowerUpOrbs | CollisionCategoryBlackHoles
        playerNode!.physicsBody!.collisionBitMask = 0



//        let moveFirstAction = SKAction.moveTo(CGPointMake(20, 650), duration: 2)
//        let moveSecondAction = SKAction.moveTo(CGPointMake(self.size.width, 1400), duration: 4)
//        let moveThirdAction = SKAction.moveTo(CGPointMake(20, 2150), duration: 3)
//        let moveFourthAction = SKAction.moveTo(CGPointMake(self.size.width, 3500), duration: 4)
//        let moveFifthAction = SKAction.moveTo(CGPointMake(100, 4600), duration: 4)
//        let actionSequence = SKAction.sequence([moveFirstAction, moveSecondAction, moveThirdAction, moveFourthAction, moveFifthAction])
//
//        playerNode!.runAction(actionSequence)



        foregroundNode!.addChild(playerNode!)
    }


    func addOrbsToForeground()
    {
        var orbNodePosition = CGPoint(x: playerNode!.position.x, y: playerNode!.position.y + 100)
        var orbXShift : CGFloat = -1.0

        for _ in 1...50
        {
            var orbNode = SKSpriteNode(imageNamed: "star")

            if orbNodePosition.x - (orbNode.size.width * 2) <= 0
            {
                orbXShift = 1.0
            }

            if orbNodePosition.x + orbNode.size.width >= self.size.width
            {
                orbXShift = -1.0
            }

            orbNodePosition.x += 40.0 * orbXShift
            orbNodePosition.y += 120
            orbNode.position = orbNodePosition
            orbNode.physicsBody = SKPhysicsBody(circleOfRadius: orbNode.size.width / 2)
            orbNode.physicsBody!.dynamic = false

            orbNode.physicsBody!.categoryBitMask = CollisionCategoryPowerUpOrbs
            orbNode.physicsBody!.collisionBitMask = 0

            orbNode.name = "POWER_UP_ORB"

            foregroundNode!.addChild(orbNode)
        }
    }


    func addBadGuys()
    {
        let moveLeftAction = SKAction.moveToX(0, duration: 1.5)
        let moveRightAction = SKAction.moveToX(self.size.width, duration: 1.5)
        let actionSequence = SKAction.sequence([moveLeftAction, moveRightAction])
        let moveAction = SKAction.repeatActionForever(actionSequence)

        for i in 1...4
        {
            var badguy = SKSpriteNode(imageNamed: "enemy")

            badguy.position = CGPointMake(self.size.width, 600.0 * CGFloat(i))
            badguy.physicsBody = SKPhysicsBody(circleOfRadius: badguy.size.width / 2)
            badguy.physicsBody!.dynamic = false

            badguy.physicsBody!.categoryBitMask = CollisionCategoryBlackHoles
            badguy.name = "BLACK_HOLE"

            badguy.runAction(moveAction)

            foregroundNode!.addChild(badguy)
        }

        let moveLeftAction2 = SKAction.moveToX(0, duration: 0.8)
        let moveRightAction2 = SKAction.moveToX(self.size.width, duration: 0.8)
        let actionSequence2 = SKAction.sequence([moveLeftAction2, moveRightAction2])
        let moveAction2 = SKAction.repeatActionForever(actionSequence2)

        for i in 5...8
        {
            var badguy = SKSpriteNode(imageNamed: "enemy")

            badguy.position = CGPointMake(self.size.width, 600.0 * CGFloat(i))
            badguy.physicsBody = SKPhysicsBody(circleOfRadius: badguy.size.width / 2)
            badguy.physicsBody!.dynamic = false

            badguy.physicsBody!.categoryBitMask = CollisionCategoryBlackHoles
            badguy.physicsBody!.collisionBitMask = 0
            badguy.name = "BLACK_HOLE"

            badguy.runAction(moveAction2)

            foregroundNode!.addChild(badguy)
        }

        let moveLeftAction3 = SKAction.moveToX(0.0, duration: 0.5)
        let moveRightAction3 = SKAction.moveToX(self.size.width, duration: 0.5)
        let actionSequence3 = SKAction.sequence([moveLeftAction3, moveRightAction3])
        let moveAction3 = SKAction.repeatActionForever(actionSequence3)

        for i in 9...10
        {
            var badguy = SKSpriteNode(imageNamed: "enemy")

            badguy.position = CGPointMake(self.size.width - 80.0, 600.0 * CGFloat(i))
            badguy.physicsBody = SKPhysicsBody(circleOfRadius: badguy.size.width / 2)
            badguy.physicsBody!.dynamic = false

            badguy.physicsBody!.categoryBitMask = CollisionCategoryBlackHoles
            badguy.physicsBody!.collisionBitMask = 0
            badguy.name = "BLACK_HOLE"

            badguy.runAction(moveAction3)

            foregroundNode!.addChild(badguy)
        }
    }



    
    // This method executes when the user touches the screen.
    override func touchesBegan(touches: Set <NSObject>, withEvent event: UIEvent)
    {
        if playerNode != nil
        {
            if !playerNode!.physicsBody!.dynamic
            {
                // Removes the "Tap Anywhere to Start" label once the screen has been tapped.
                startGameTextNode.removeFromParent()

                playerNode!.physicsBody!.dynamic = true

                self.coreMotionManager.accelerometerUpdateInterval = 0.3

                self.coreMotionManager.startAccelerometerUpdatesToQueue(NSOperationQueue(), withHandler:
                {
                        (data: CMAccelerometerData!, error: NSError!) in

                        if let constVar = error
                        {
                            println("An error was encountered.")
                        }
                        else
                        {
                            self.xAxisAcceleration = CGFloat(data!.acceleration.x)
                        }
                })
            }

            if impulseCount > 0
            {
                playerNode!.physicsBody!.applyImpulse(CGVectorMake(0.0, 80.0))
                impulseCount--

                impulseTextNode.text = "IMPULSES : \(impulseCount)"

                // Shows fire coming from engine.
                self.engineExhaust!.hidden = false
                
                NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "hideEngineExhaust:", userInfo: nil, repeats: false)
            }
        }
    }









    // This method executes when the player node (the spaceship) touches either orbs or black holes.
    func didBeginContact(contact: SKPhysicsContact)
    {
        var nodeB = contact.bodyB!.node!

        if nodeB.name == "POWER_UP_ORB"
        {
            // Plays orb pop sound.
            runAction(orbPopAction)

            // Adds an impulse to total impulses.
            impulseCount++

            // Updates the impulse label.
            impulseTextNode.text = "IMPULSES : \(impulseCount)"

            // Adds one point to the score.
            score++

            // Updates the score label.
            scoreTextNode.text = "SCORE : \(score)"

            // Removes orb from screen.
            nodeB.removeFromParent()
        }

        else if nodeB.name == "BLACK_HOLE"
        {
            // Disables players ability to collide with objects.
            playerNode!.physicsBody!.contactTestBitMask = 0

            // Removes all impulses.
            impulseCount = 0

            // Turns the player red when he touches a black hole.
            var colorizeAction = SKAction.colorizeWithColor(UIColor.redColor(), colorBlendFactor: 1.0, duration: 0.8)

            // Runs the action.
            playerNode!.runAction(colorizeAction)

            // Removes black hole from screen.
            nodeB.removeFromParent()
        }



    }









    override func update(currentTime: NSTimeInterval)
    {
        if playerNode != nil
        {
            if playerNode!.position.y >= 180.0 && playerNode!.position.y < 6400.0
            {
                backgroundNode!.position = CGPointMake(self.backgroundNode!.position.x, -((self.playerNode!.position.y - 180.0) / 8))
                
                //UNCOMMENT IF NEEDED
//                backgroundStarsNode!.position = CGPointMake(backgroundStarsNode!.position.x, -((playerNode!.position.y - 180.0) / 6))
//
                //backgroundPlanetNode!.position = CGPointMake(backgroundPlanetNode!.position.x, -((playerNode!.position.y - 180.0) / 8))

                foregroundNode!.position = CGPointMake(foregroundNode!.position.x, -(playerNode!.position.y - 180.0))
            }

            else if playerNode!.position.y > 7000
            {
                gameOverWithResult(true)
            }

            else if playerNode!.position.y < 0.0
            {
                gameOverWithResult(false)
            }
        }
    }



    override func didSimulatePhysics()
    {

        if playerNode != nil
        {

            self.playerNode!.physicsBody!.velocity = CGVectorMake(self.xAxisAcceleration * 380.0, self.playerNode!.physicsBody!.velocity.dy)

            if playerNode!.position.x < -(playerNode!.size.width / 2)
            {
                playerNode!.position = CGPointMake(size.width - playerNode!.size.width / 2, playerNode!.position.y)
            }

            else if self.playerNode!.position.x > self.size.width
            {
                playerNode!.position = CGPointMake(playerNode!.size.width / 2, playerNode!.position.y)
            }
        }
    }



    deinit
    {
        self.coreMotionManager.stopAccelerometerUpdates()
    }



    func hideEngineExhaust(timer: NSTimer!)
    {
        if !engineExhaust!.hidden
        {
            engineExhaust!.hidden = true
        }
    }



    func gameOverWithResult(gameResult: Bool)
    {
        playerNode!.removeFromParent()
        playerNode = nil

        let transition = SKTransition.fadeWithDuration(3)
        let menuScene = MenuScene(size: size, gameResult: gameResult, score: score)

        view?.presentScene(menuScene, transition: transition)
    }

}






















