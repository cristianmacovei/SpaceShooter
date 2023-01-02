//
//  GameOverScene.swift
//  SS Game
//
//  Created by Cristian Macovei on 05.12.2022.
//

import Foundation
import SpriteKit

class GameOverScene : SKScene {
    
    let playAgainLabel = SKLabelNode(fontNamed: "moonhouse.ttf")
    
    override func didMove(to view: SKView) {
        
        //Background of the scene
        let background = SKSpriteNode(imageNamed: "spaceWallpaper")
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.zPosition = 0
        background.size = self.size
        self.view!.contentMode = .scaleAspectFit
        self.addChild(background)
        
        //Label Saying "GameOver"
        let gameOverLabel = SKLabelNode(fontNamed: "moonhouse.ttf")
        gameOverLabel.text = "GAME OVER"
        gameOverLabel.fontSize = 45
        gameOverLabel.horizontalAlignmentMode = .center
        gameOverLabel.position = CGPoint(x: self.size.width/2, y: self.size.height*0.75)
        gameOverLabel.zPosition = 5
        gameOverLabel.fontColor = .white
        self.addChild(gameOverLabel)
        
        
        //Label with final score
        let finalScoreLabel = SKLabelNode(fontNamed: "moonhouse.ttf")
        finalScoreLabel.text = "Score: \(gameScore)"
        finalScoreLabel.fontSize = 45
        finalScoreLabel.position = CGPoint(x: self.size.width/2, y: self.size.height*0.55)
        finalScoreLabel.zPosition = 1
        finalScoreLabel.fontColor = .white
        self.addChild(finalScoreLabel)
        
        //Access Savedata
        let userDefaults = UserDefaults()
        var highScore = userDefaults.integer(forKey: "highScore")
        
        if gameScore > highScore {
            highScore = gameScore
            userDefaults.set(highScore, forKey: "highScore")
        }
        
        let highScoreLabel = SKLabelNode(fontNamed: "moonhouse.ttf")
        highScoreLabel.text = "High Score: \(highScore)"
        highScoreLabel.fontSize = 45
        highScoreLabel.fontColor = .white
        highScoreLabel.position = CGPoint(x: self.size.width/2, y: self.size.height*0.45)
        highScoreLabel.zPosition = 1
        self.addChild(highScoreLabel)
        
        //Restart Label
        playAgainLabel.text = "Play Again"
        playAgainLabel.fontSize = 45
        playAgainLabel.fontColor = .white
        playAgainLabel.position = CGPoint(x: self.size.width/2, y: self.size.height*0.25)
        playAgainLabel.zPosition = 1
        self.addChild(playAgainLabel)
        
    }
    
    //Transform play again label into button
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let touchPos = touch.location(in: self)
            
            if playAgainLabel.contains(touchPos) {
                let startNewGame = GameScene(size: self.size)
                startNewGame.scaleMode = self.scaleMode
                self.view!.presentScene(startNewGame, transition: SKTransition.fade(withDuration: 0.3))
            }
        }
    }
    
}
