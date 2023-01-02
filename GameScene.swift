//
//  GameScene.swift
//  SS Game
//
//  Created by Cristian Macovei on 02.12.2022.
//

import SpriteKit
import GameplayKit
import CoreMotion
import UIKit

var gameScore = 0

class GameScene: SKScene, SKPhysicsContactDelegate, UIViewControllerPreviewingDelegate {
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        return UIViewController()
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        return
    }
    
    
    //Declare PhysicsCategories for the GameObjects
    struct PhysicsCategories {
        static let None: UInt32 = 0               // 0
        static let Player: UInt32 = 0b1         // 1
        static let Missile: UInt32 = 0b10       // 2
        static let Meteorite: UInt32 = 0b100    // 3
    }
    
    //Declare gameStates
    enum gameState {
        case preGame
        case inGame
        case endGame
    }
    
    var currentGameState = gameState.preGame
    
    //Create MotionManager to fetch accelerometer data
    let motionManager = CMMotionManager()
    
    
    //Create game Info Labels
    var missileCountLabel: SKLabelNode = SKLabelNode(fontNamed: "moonhouse.ttf")
    var numberOfLivesLabel: SKLabelNode = SKLabelNode(fontNamed: "moonhouse.ttf")
    var gameScoreLabel: SKLabelNode = SKLabelNode(fontNamed: "moonhouse.ttf")
    var levelNumberLabel: SKLabelNode = SKLabelNode(fontNamed: "moonhouse.ttf")
    var startGameLabel: SKLabelNode = SKLabelNode(fontNamed: "moonhouse.ttf")
    var shieldCounterLabel: SKLabelNode = SKLabelNode(fontNamed: "moonhouse.ttf")
    
    //Initialize the game Info Labels wth variables
    var missileCount = 100
    var numberOfLives = 5
    var levelNumber = 1
    var shieldsAvailable = 0
    var hitsCounter = 0
    
    //Labels
    let player = SKSpriteNode(imageNamed: "spaceShip")
    let rocketCountLabel = SKLabelNode(fontNamed: "moonhouse.ttf")
    let outOfMissilesLabel = SKLabelNode(fontNamed: "moonhouse.ttf")
    
    //Create a Game Area the size of the display
    var gameArea: CGRect
    
    //Init for gameArea by size
    override init(size: CGSize) {
        let maxAspectRatio = CGFloat(16.0/9.0)
        let playableWidth = size.width/maxAspectRatio
        let margin = (size.width - playableWidth)/2
        gameArea = CGRect(x: margin, y: 0, width: playableWidth, height: size.height)
        super.init(size: size)
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        return nil
    }
    
    
    //Method to start fetching Accelerometer data
    func startAccelerometerData() {
        
        if self.motionManager.isAccelerometerAvailable {
            self.motionManager.startAccelerometerUpdates()
            
            //Check if data is your accelerometer data (or anything that is always true)
            if let data = self.motionManager.accelerometerData {
                //Create a var that stores that data
                let x = CGFloat(data.acceleration.x)
                
                //IN HERE WE CAN ALSO JUST UPDATE PLAYER.POSITION.X BY X*100 WITHOUT THE IFS
                
                //Move right for x>0 & left for x<0
                if x > 0 {
                    player.position.x += x*100
                    //print(player.position.x)
                }
                else if x < 0 {
                    player.position.x += x*100
                    //print(player.position.x)
                }
                
                //Switch sides if spaceShip goes out of the screen
                if player.position.x > gameArea.maxX + player.size.width {
                    player.position.x = gameArea.minX - player.size.width
                }
                else if player.position.x < gameArea.minX - player.size.width {
                    player.position.x = gameArea.maxX + player.size.width
                }
            }
        }
    }
    
    var timer = Timer()
    
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    var rocketCount = 20
    
    //CREATE ALL OBJECTS TO APPEAR ON THE SCREEN
    override func didMove(to view: SKView) {
        
        gameScore = 0
        
        self.physicsWorld.contactDelegate = self
        
        //Level Label
        levelNumberLabel.text = "Leve: \(levelNumber)"
        levelNumberLabel.fontSize = 20
        levelNumberLabel.fontColor = .white
        levelNumberLabel.position = CGPoint(x: self.size.width*0.8, y: self.size.height*0.925)
        levelNumberLabel.zPosition = 4
        self.addChild(levelNumberLabel)
        
        let levelNumberAction = SKAction.move(to: CGPoint(x: self.size.width*0.8, y: self.size.height*0.925), duration: 0.5)
        levelNumberLabel.run(levelNumberAction)
        
        //Counter for lives
        numberOfLivesLabel.text = "Lives: \(numberOfLives)"
        numberOfLivesLabel.fontSize = 20
        let numberOfLivesPosition = CGPoint(x: self.size.width*0.14, y: self.size.height*0.87)
        numberOfLivesLabel.position = numberOfLivesPosition
        numberOfLivesLabel.zPosition = 100
        numberOfLivesLabel.horizontalAlignmentMode = .center
        
        let moveToScreenAction = SKAction.move(to: numberOfLivesPosition, duration: 0.5)
        numberOfLivesLabel.run(moveToScreenAction)
        
        
        //Game Score Label
        gameScoreLabel.text = "Score: \(gameScore)"
        gameScoreLabel.fontSize = 20
        gameScoreLabel.horizontalAlignmentMode = .left
        let gameScoreLabelPosition = CGPoint(x: self.size.width*0.045, y: self.size.height*0.9)
        gameScoreLabel.position = gameScoreLabelPosition
        gameScoreLabel.zPosition = 100
        
        
        let moveToScreenAction2 = SKAction.move(to: gameScoreLabelPosition, duration: 0.5)
        gameScoreLabel.run(moveToScreenAction2)
        
        //Missile Counter Label
        missileCountLabel.text = "Missiles: \(missileCount)"
        missileCountLabel.fontSize = 20
        let missileCountPosition = CGPoint(x: self.size.width*0.05, y: self.size.height*0.84)
        missileCountLabel.position = missileCountPosition
        missileCountLabel.zPosition = 0.5
        missileCountLabel.horizontalAlignmentMode = .left
        
        let moveToScreenAction3 = SKAction.move(to: missileCountPosition, duration: 0.5)
        missileCountLabel.run(moveToScreenAction3)
        
        
        //Shield Count Label
        shieldCounterLabel.text = "Shields: \(shieldsAvailable)"
        shieldCounterLabel.fontSize = 20
        let shieldCountPosition = CGPoint(x: self.size.width*0.95, y: self.size.height*0.93)
        shieldCounterLabel.horizontalAlignmentMode = .right
        shieldCounterLabel.position = shieldCountPosition
        shieldCounterLabel.zPosition = 5
        
        //Counter for the rockets
        rocketCountLabel.text = "Rockets: \(rocketCount)"
        rocketCountLabel.fontSize = 20
        rocketCountLabel.position = CGPoint(x: self.size.width*0.05, y: self.size.height*0.93)
        rocketCountLabel.zPosition = 0.5
        rocketCountLabel.horizontalAlignmentMode = .left
        
        //Player Node
        player.setScale(0.18)
        //print(player.size)
        //player.position = CGPoint(x: self.size.width/2, y: -self.size.height*0.2)
        player.position.x = self.size.width/2
        player.position.y = self.size.height*(-0.2)
        player.zPosition = 2
        
        //Player PhysicsBody
        
        let lowerPoint = CGPoint(x: player.position.x-111, y: player.position.y/5)
        print(player.position.x)
        print(lowerPoint.x)
        let rect1 = SKPhysicsBody(rectangleOf: CGSize(width: 20, height: 110))
        let rect2 = SKPhysicsBody(rectangleOf: CGSize(width: 111.5, height: 20), center: lowerPoint)
        let spaceShipPhysicsBody = SKPhysicsBody(bodies: [rect1, rect2])
        
        player.physicsBody = spaceShipPhysicsBody
        player.physicsBody?.affectedByGravity = false
        player.physicsBody?.categoryBitMask = PhysicsCategories.Player
        player.physicsBody?.contactTestBitMask = PhysicsCategories.Meteorite
        player.physicsBody?.collisionBitMask = PhysicsCategories.None
        player.name = "Player"
        
        //Background Image Node
        let background = SKSpriteNode(imageNamed: "spaceWallpaper")
        background.size = self.size
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.zPosition = 0
        
        
        //Tap to play Label
        startGameLabel.text = "Start Game"
        startGameLabel.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        startGameLabel.zPosition = 1
        startGameLabel.fontSize = 50
        startGameLabel.fontColor = .white
        startGameLabel.alpha = 0
        
        let fadeIn = SKAction.fadeIn(withDuration: 0.3)
        startGameLabel.run(fadeIn)
        
        //Add items to the scene
        self.addChild(rocketCountLabel)
        self.addChild(background)
        self.addChild(player)
        self.addChild(missileCountLabel)
        self.addChild(numberOfLivesLabel)
        self.addChild(gameScoreLabel)
        //self.addChild(shieldCounterLabel)
        self.addChild(startGameLabel)
        
    }
    
    //Function to add score
    func addScore() {
        gameScore += 1
        gameScoreLabel.text = "Score: \(gameScore)"
        
        switch gameScore {
        case 10:
            startNewLevel()
        case 25:
            startNewLevel()
        case 50:
            startNewLevel()
        case 65:
            startNewLevel()
        default:
            return
        }
        
    }
    
    //Method to subtract number of lives
    func subtractNumberOfLives() {
        numberOfLives -= 1
        numberOfLivesLabel.text = "Lives: \(numberOfLives)"
        
        let scaleUp = SKAction.scale(to: 1.5, duration: 0.2)
        let scaleDown = SKAction.scale(to: 1, duration: 0.2)
        let scaleUpAndDownSequence = SKAction.sequence([scaleUp, scaleDown])
        
        numberOfLivesLabel.run(scaleUpAndDownSequence)
        
        if numberOfLives == 0 {
            gameOver()
        }
        
    }
    
    //Method for Game Over
    func gameOver() {
        currentGameState = .endGame
        self.removeAllActions()
        self.enumerateChildNodes(withName: "Missile") {
            missile, stop in
            missile.removeAllActions()
        }
        self.enumerateChildNodes(withName: "Meteorite") {
            meteorite, stop in
            meteorite.removeAllActions()
        }
        print("Score: \(gameScore)")
        
        let changeSceneAction = SKAction.run(changeScene)
        let wait = SKAction.wait(forDuration: 1)
        let changeSceneSequence = SKAction.sequence([changeSceneAction, wait])
        
        self.run(changeSceneSequence)
        
    }
    
    func changeScene() {
        let sceneToMove = GameOverScene(size: self.size)
        sceneToMove.scaleMode = .aspectFill
        let transition = SKTransition.fade(withDuration: 1)
        self.view!.presentScene(sceneToMove, transition: transition)
    }
    
    //Create new Level
    func startNewLevel() {
        
        levelNumber += 1
        
        //Stop enemies from spawning
        if self.action(forKey: "spawningEnemies") != nil {
            self.removeAction(forKey: "spawningEnemies")
        }
        
        //Declare a variable for spawning Duration
        var spawnDuration = TimeInterval()
        
        //Level Cases with respect to spawning Duration
        switch levelNumber {
        case 1:
            spawnDuration = 2
        case 2:
            spawnDuration = 1.8
        case 3:
            spawnDuration = 1.6
        case 4:
            spawnDuration = 1.4
        case 5:
            spawnDuration = 1.2
        case 6:
            spawnDuration = 1
        case 7:
            spawnDuration = 0.8
        case 8:
            spawnDuration = 0.6
        default:
            spawnDuration = 0.6
        }
        
        let spawn = SKAction.run(spawnMeteorite)
        
        //Time between Spawning meteorites
        let waitToSpawn = SKAction.wait(forDuration: spawnDuration)
        let spawnSequence = SKAction.sequence([waitToSpawn, spawn])
        let spawnForever = SKAction.repeatForever(spawnSequence)
        self.run(spawnForever, withKey: "spawningEnemies")
        
    }
    
    func fireMissile() {
        
        //Create a CGRect for physicsBody for missile
        let missilePhysicsBodyRect = CGRect(x: self.player.position.x, y: self.player.position.y, width: 25.6, height: 25.6)
        
        //Instantiate Missile
        let missile = SKSpriteNode(imageNamed: "missile")
        missile.setScale(0.05)
        missile.name = "Missile"
        missile.position = player.position
        missile.zPosition = 2
        self.addChild(missile)
        
        missile.physicsBody = SKPhysicsBody(rectangleOf: missilePhysicsBodyRect.size)
        missile.physicsBody?.affectedByGravity = false
        missile.physicsBody?.categoryBitMask = PhysicsCategories.Missile
        missile.physicsBody?.collisionBitMask = PhysicsCategories.Meteorite
        missile.physicsBody?.contactTestBitMask = PhysicsCategories.Meteorite
        //print(missilePhysicsBodyRect.size)
        //print(missile.size)
        
        //Run in this order
        let rotation = SKAction.rotate(toAngle: CGFloat.pi / 4.0, duration: 0.01)
        let moveMissile = SKAction.move(to: CGPoint(x: self.player.position.x, y:self.size.height + missile.size.height), duration: 0.4)
        let destroyMissile = SKAction.removeFromParent()
        
        //Create sequence from the above
        let missileSequence = SKAction.sequence([rotation, moveMissile, destroyMissile])
        missile.run(missileSequence)
        if missileCount == 0 {
            gameOver()
        }
        
    }
    
    func startGame() {
        
        //startGyros()
        startAccelerometerData()
        currentGameState = .inGame
        
        let deleteStartButton = SKAction.sequence([SKAction.fadeOut(withDuration: 0.5), SKAction.removeFromParent()])
        startGameLabel.run(deleteStartButton)
        
        let movePlayerToStart = SKAction.move(to: CGPoint(x: self.size.width/2, y: self.size.height*0.2), duration: 0.5)
        let startLevelAction = SKAction.run(startNewLevel)
        let startSequence = SKAction.sequence([movePlayerToStart, startLevelAction])
        player.run(startSequence)
        
    }
    
    func addMissiles(amount: Int) {
        missileCount += amount
        missileCountLabel.text = "Missiles: \(missileCount)"
    }
    
    func removeMissile() {
        missileCount -= 1
        missileCountLabel.text = "Missiles: \(missileCount)"
    }
    
    func addShield() {
        shieldsAvailable += 1
        shieldCounterLabel.text = "Shield: \(shieldsAvailable)"
    }
    
    func removeShieldAvailable() {
        shieldsAvailable -= 1
        shieldCounterLabel.text = "Shield: \(shieldsAvailable)"
    }
    
    func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return CGFloat.random(in: min...max)
    }
    
    var meteorite: SKSpriteNode!
    func spawnMeteorite() {
        
        let randomXStart = random(min: gameArea.minX, max: gameArea.maxX)
        let randomXEnd = random(min: gameArea.minX, max: gameArea.maxX)
        
        let startPoint = CGPoint(x: randomXStart, y: self.size.height*1.2)
        let endPoint = CGPoint(x: randomXEnd, y: -self.size.height*0.2)
        
        meteorite = SKSpriteNode(imageNamed: "meteor")
        meteorite.setScale(0.75)
        meteorite.name = "Meteorite"
        meteorite.physicsBody = SKPhysicsBody(circleOfRadius: 24)
        meteorite.physicsBody?.categoryBitMask = PhysicsCategories.Meteorite
        meteorite.physicsBody?.collisionBitMask = PhysicsCategories.Missile & PhysicsCategories.Player
        meteorite.physicsBody?.contactTestBitMask = PhysicsCategories.Missile & PhysicsCategories.Player
        
        //print(meteorite.size)
        
        meteorite.position = startPoint
        meteorite.zPosition = 2
        
        self.addChild(meteorite)
        
        let moveMeteorite = SKAction.move(to: endPoint, duration: 1.8)
        let deleteMeteorite = SKAction.removeFromParent()
        let meteoriteSequence = SKAction.sequence([moveMeteorite, deleteMeteorite])
        meteorite.run(meteoriteSequence)
        
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.blue
            self.addChild(n)
        }
    }
    
    /*
     func touchDown(atPoint pos : CGPoint) {
     if let n = self.spinnyNode?.copy() as! SKShapeNode? {
     n.position = pos
     n.strokeColor = SKColor.green
     self.addChild(n)
     }
     }
     
     
     func touchUp(atPoint pos : CGPoint) {
     if let n = self.spinnyNode?.copy() as! SKShapeNode? {
     n.position = pos
     n.strokeColor = SKColor.red
     self.addChild(n)
     }
     }
     */
    
    func spawnExplosion() {
        let explosion = SKSpriteNode(imageNamed: "explosion")
        //explosion.size = 1
        explosion.position = meteorite.position
        explosion.name = "Explosion"
        explosion.zPosition = 5
        
        self.addChild(explosion)
        
        let explosionFadeIn = SKAction.fadeIn(withDuration: 0.1)
        let explosionScaleIn = SKAction.scale(to: 1.5, duration: 0.1)
        let deleteExplosion = SKAction.removeFromParent()
        let explosionSequence = SKAction.sequence([explosionFadeIn, explosionScaleIn, deleteExplosion])
        explosion.run(explosionSequence)
        meteorite.removeFromParent()
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        var body1 = SKPhysicsBody()
        var body2 = SKPhysicsBody()
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            body1 = contact.bodyA
            body2 = contact.bodyB
        } else {
            body1 = contact.bodyB
            body2 = contact.bodyA
        }
        //PLAYER hits METEORITE
        if body1.categoryBitMask == PhysicsCategories.Player && body2.categoryBitMask == PhysicsCategories.Meteorite {
            if body1.node != nil {
                spawnExplosion()
                subtractNumberOfLives()
                if numberOfLives == 0 {
                    body1.node?.removeFromParent()
                    gameOver()
                }
            }
            if body2.node != nil {
                spawnExplosion()
            }
            body2.node?.removeFromParent()
        }
        if body1.categoryBitMask == PhysicsCategories.Missile && body2.categoryBitMask == PhysicsCategories.Meteorite && (body2.node?.position.y)! < self.size.height {
            addScore()
            
            hitsCounter += 1
            if hitsCounter % 10 == 0 {
                addMissiles(amount: 10)
                addShield()
            }
            if body2.node != nil {
                spawnExplosion()
            }
            body1.node?.removeFromParent()
            body2.node?.removeFromParent()
        }
        
        
        //THIS EXECUTES TWICE FOR EVERY COLLISION
        //EXAMPLE: PLAYER & METEORITE -> PLAYER HITS METEORITE &&& METEORITE HITS PLAYER
        // ===>> INCORRECT SCORE & LIVES COUNTERS
        
        
        /*if contact.bodyA.node?.name == "Player" && contact.bodyB.node?.name == "Meteorite" {
         subtractNumberOfLives()
         print("Contact between Player & Meteorite")
         }
         if contact.bodyA.node?.name == "Missile" && contact.bodyB.node?.name == "Meteorite" {
         addScore()
         if levelNumber % 2 == 0 {addMissiles(amount: 20)}
         spawnExplosion()
         print("Contact between Missile & Meteorite")
         }*/
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if currentGameState == .preGame { startGame() } else { fireMissile() }
        if missileCount > 0 && currentGameState == .inGame {
            fireMissile()
            removeMissile()
        } else {
            gameOver()
            motionManager.stopAccelerometerUpdates()
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
        super.touchesMoved(touches, with: event)
    }
    
    /*
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }*/
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        if currentGameState == .inGame{
            startAccelerometerData() } else { print("not ingame")}
        //print(player.size)
    }
}
