//
//  MainMenuScene.swift
//  SuperSpaceMan2
//
//  Created by Adam Johnson on 6/24/15.
//  Copyright (c) 2015 Adam. All rights reserved.
//

import Foundation
import SpriteKit
import CoreMotion


class MainMenuScene: SKScene, SKPhysicsContactDelegate
{

    var titleLabel = SKLabelNode(fontNamed: "Copperplate")
    var tapScreenLabel = SKLabelNode(fontNamed: "Copperplate")
    var backgroundOne : SKSpriteNode?
    var backgroundTwo : SKSpriteNode?
    var ship1 : SKSpriteNode?
    var ship2 : SKSpriteNode?
    var ship3 : SKSpriteNode?

    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }


    override init(size: CGSize)
    {
        super.init(size: size)

        addBackgroundOne()
        addBackgroundTwo()
        addMainMenuSceneLabels()
        addShips()
    }

    
    func addShips()
    {
        // Ship 1
        ship1 = SKSpriteNode(imageNamed: "greenship")
        ship1!.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        ship1!.position = CGPoint(x: self.size.width / 2.0, y: -50.0) //50
        let moveUpAction = SKAction.moveToY(800, duration: 2)
        ship1!.runAction(moveUpAction)

        addChild(ship1!)


        // Ship 2
        ship2 = SKSpriteNode(imageNamed: "orangeship")
        ship2!.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        ship2!.position = CGPoint(x: self.size.width, y: -700) //50
        let moveOverAction = SKAction.moveTo(CGPointMake(0.0, 800), duration: 3)
        ship2!.runAction(moveOverAction)

        addChild(ship2!)


        // Ship 3
        ship3 = SKSpriteNode(imageNamed: "blueship")
        ship3!.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        ship3!.position = CGPoint(x: 0, y: -1200) //50
        let moveRightAction = SKAction.moveTo(CGPointMake(self.size.width, 800), duration: 4)
        ship3!.runAction(moveRightAction)
        
        addChild(ship3!)
    }


    func addBackgroundOne()
    {
        backgroundOne = SKSpriteNode(imageNamed: "sparsespace")
        backgroundOne!.anchorPoint = CGPoint(x: 0.5, y: 0)
        backgroundOne!.position = CGPoint(x: self.size.width / 2.0, y: 0)

        addChild(backgroundOne!)
    }


    func addBackgroundTwo()
    {
        backgroundTwo = SKSpriteNode(imageNamed: "sparsespace")
        backgroundTwo!.anchorPoint = CGPoint(x: 0.5, y: 0)
        backgroundTwo!.position = CGPoint(x: self.size.width / 4.0, y: backgroundOne!.position.y + backgroundOne!.size.height)

        addChild(backgroundTwo!)
    }


    override func update(currentTime: NSTimeInterval)
    {
        backgroundOne!.position = CGPointMake(self.size.width / 2, backgroundOne!.position.y - 2)

        backgroundTwo!.position = CGPointMake(self.size.width / 2, backgroundTwo!.position.y - 2)

        if backgroundOne!.position.y < -800 //-backgroundOne!.size.height
        {
            backgroundOne!.position = CGPointMake(self.size.width / 2, backgroundTwo!.position.y + 800)
        }

        if backgroundTwo!.position.y < -800 //-backgroundTwo!.size.height
        {
            backgroundTwo!.position = CGPointMake(self.size.width / 2, backgroundOne!.position.y + 800)
        }
    }


    func addMainMenuSceneLabels()
    {
        titleLabel.text = "Space Gauntlet"
        titleLabel.fontSize = 35
        titleLabel.fontColor = SKColor.whiteColor()
        titleLabel.position = CGPointMake(size.width / 2, size.height / 2 + 100)
        addChild(titleLabel)

        tapScreenLabel.text = "Tap Screen To Begin"
        tapScreenLabel.fontSize = 20
        tapScreenLabel.fontColor = SKColor.whiteColor()
        tapScreenLabel.position = CGPointMake(size.width / 2, size.height / 2 - 100)
        addChild(tapScreenLabel)
    }


    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent)
    {

        let transition = SKTransition.fadeWithDuration(1)
        let gameScene = GameScene(size: size)

        view?.presentScene(gameScene, transition: transition)
    }

}