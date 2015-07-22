//
//  GameViewController.swift
//  SuperSpaceMan2
//
//  Created by Adam Johnson on 6/15/15.
//  Copyright (c) 2015 Adam. All rights reserved.
//

import UIKit
import SpriteKit

//extension SKNode
//{
//    class func unarchiveFromFile(file : String) -> SKNode?
//    {
//        if let path = NSBundle.mainBundle().pathForResource(file, ofType: "sks")
//        {
//            var sceneData = NSData(contentsOfFile: path, options: .DataReadingMappedIfSafe, error: nil)!
//            var archiver = NSKeyedUnarchiver(forReadingWithData: sceneData)
//            
//            archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
//            let scene = archiver.decodeObjectForKey(NSKeyedArchiveRootObjectKey) as! GameScene
//            archiver.finishDecoding()
//            return scene
//        }
//        else
//        {
//            return nil
//        }
//    }
//}


class GameViewController: UIViewController
{
    var scene: MainMenuScene!

    override func prefersStatusBarHidden() -> Bool
    {
        return true
    }

    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Configure the main view.
        let skView = view as! SKView
        // Turns on the frames per second display.
        //skView.showsFPS = true

        // Create and configure the game scene.
        scene = MainMenuScene(size: skView.bounds.size)
        scene.scaleMode = .AspectFill

        // Show the scene.
        skView.presentScene(scene)
        
        
        
    }
}

















