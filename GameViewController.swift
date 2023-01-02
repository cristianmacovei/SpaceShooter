//
//  GameViewController.swift
//  SS Game
//
//  Created by Cristian Macovei on 02.12.2022.
//

import UIKit
import SpriteKit
import GameplayKit



class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //Load GameScene.sks as a GKScene. This provides gameplay relateed content including entities and graphs
        let scene = GameScene(size: CGSize(width: self.view.bounds.width, height: self.view.bounds.height))
        
        //Configure the view
        let view = self.view as! SKView
        
        view.showsFPS = true
        view.showsNodeCount = true
        
        //Rendering improvements by SpriteKit
        view.ignoresSiblingOrder = true
        
        //Set scale mode to fit window
        scene.scaleMode = .aspectFill
        view.presentScene(scene)
        
        
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

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
