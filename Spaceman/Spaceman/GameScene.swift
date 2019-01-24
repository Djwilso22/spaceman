
import SpriteKit
import GameplayKit

let highScoreUserDefaultKey : String = "HIGHSCORE"
class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var spaceMan : SKSpriteNode?
    var starTimer : Timer?
    var alienTimer : Timer?
    var meteorTimer : Timer?
    var ceil : SKSpriteNode?
    var moon : SKSpriteNode?
    var scoreLabel : SKLabelNode?
    var yourScoreLabel : SKLabelNode?
    var finalScoreLabel : SKLabelNode?
    var highScoreLabel : SKLabelNode?
    var Score = 0
    var highScore = UserDefaults.standard.integer(forKey: highScoreUserDefaultKey)
    let SpaceManCategory : UInt32 = 0x1 << 1
    let starCatergory : UInt32 = 0x1 << 2
    let alienCatergory : UInt32 = 0x1 << 3
    let meteorCatergory : UInt32 = 0x1 << 4
    let CeilCategory : UInt32 = 0x1 << 4
    let defaults = UserDefaults.standard//

        
        override func didMove(to view: SKView) {
            
            physicsWorld.contactDelegate = self
            
            spaceMan = childNode(withName: "spaceMan") as? SKSpriteNode
            spaceMan?.physicsBody?.categoryBitMask = SpaceManCategory
            spaceMan?.physicsBody?.contactTestBitMask = SpaceManCategory | alienCatergory
            spaceMan?.physicsBody?.collisionBitMask = CeilCategory
            var spaceManRun : [SKTexture] = []
            for number in 1...5 {
                spaceManRun.append(SKTexture(imageNamed: "frame-\(number)"))
            }
            spaceMan?.run(SKAction.repeatForever(SKAction.animate(with: spaceManRun, timePerFrame: 0.4)))
            
            
            ceil = childNode(withName: "Moon") as? SKSpriteNode
            ceil?.physicsBody?.categoryBitMask = CeilCategory
            ceil?.physicsBody?.collisionBitMask = SpaceManCategory
            
            scoreLabel = childNode(withName: "scoreLabel") as? SKLabelNode
            highScoreLabel = childNode(withName: "highScoreLabel") as? SKLabelNode
            startTimers()
        }
        
        func startTimers() {
            
            starTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer) in
                self.createStar()
            })
            
            
            alienTimer = Timer.scheduledTimer(withTimeInterval: 4, repeats: true, block: { (timer) in
                self.createAlien()
            })
            
            
            meteorTimer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true, block: { (timer)
                in
                self.createMeteor()
            })
            
            
            
        }
        
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            if Score > UserDefaults.standard.integer(forKey: highScoreUserDefaultKey) {
                saveHighScore()
            }
            if scene?.isPaused == false {
                spaceMan?.physicsBody?.velocity = CGVector.zero
                spaceMan?.physicsBody?.applyForce(CGVector(dx: 0, dy: 50000))
            }
            
            let touch = touches.first
            if let location = touch?.location(in: self) {
                let theNodes = nodes(at: location)
                
                for node in theNodes {
                    if node.name == "play" {
                        // Restart the game
                        Score = 0
                        node.removeFromParent()
                        finalScoreLabel?.removeFromParent()
                        yourScoreLabel?.removeFromParent()
                        scene?.isPaused = false
                        scoreLabel?.text = "Score: \(Score)"
                        startTimers()
                    }
                }
            }
        }
        
        func createStar() {
            let star = SKSpriteNode(imageNamed: "star")
            star.physicsBody = SKPhysicsBody(rectangleOf: star.size)
            star.physicsBody?.affectedByGravity = false
            star.physicsBody?.categoryBitMask = starCatergory
            star.physicsBody?.contactTestBitMask = SpaceManCategory
            star.physicsBody?.collisionBitMask = 0
            star.zPosition = 3
            addChild(star)
            
            let sizingMoon = SKSpriteNode(imageNamed: "Moon")
            let maxY = size.height / 2 - size.height / 2
            let minY = -size.height / 2 + star.size.height / 2 + sizingMoon.size.height
            let range = maxY - minY
            let starY = maxY - CGFloat(arc4random_uniform(UInt32(range)))
            
            star.position = CGPoint(x: size.width / 2 + star.size.width / 2, y: starY)
            
            let moveLeft = SKAction.moveBy(x: -size.width - star.size.width, y: 0, duration: 3)
            
            star.run(SKAction.sequence([moveLeft, SKAction.removeFromParent()]))
        }
        
        func createAlien() {
            let alien = SKSpriteNode(imageNamed: "alien")
            alien.physicsBody = SKPhysicsBody(rectangleOf: alien.size)
            alien.physicsBody?.affectedByGravity = false
            alien.physicsBody?.categoryBitMask = alienCatergory
            alien.physicsBody?.contactTestBitMask = SpaceManCategory
            alien.physicsBody?.collisionBitMask = 0
            alien.zPosition = 2
            addChild(alien)
            
            let sizingMoon = SKSpriteNode(imageNamed: "Moon")
            
            let maxY = size.height / 2 - alien.size.height / 2
            let minY = -size.height / 2 + alien.size.height / 2 + sizingMoon.size.height
            let range = maxY - minY
            let alieny = maxY - CGFloat(arc4random_uniform(UInt32(range)))
            
            alien.position = CGPoint(x: size.width / 2 + alien.size.width / 2, y: alieny)
            
            let moveLeft = SKAction.moveBy(x: -size.width - alien.size.width, y: 0, duration: 6)
            
            alien.run(SKAction.sequence([moveLeft, SKAction.removeFromParent()]))
        }
        
        func createMeteor() {
            let Meteor = SKSpriteNode(imageNamed: "meteor")
            Meteor.physicsBody = SKPhysicsBody(rectangleOf: Meteor.size)
            Meteor.physicsBody?.affectedByGravity = false
            Meteor.physicsBody?.categoryBitMask = meteorCatergory
            Meteor.physicsBody?.contactTestBitMask = SpaceManCategory
            Meteor.physicsBody?.collisionBitMask = 0
            Meteor.zPosition = 2
            addChild(Meteor)
            
            let sizingMoon = SKSpriteNode(imageNamed: "Moon")
            
            let maxY = size.height / 2 - Meteor.size.height / 2
            let minY = -size.height / 2 + Meteor.size.height / 2 + sizingMoon.size.height
            let range = maxY - minY
            let meteory = maxY - CGFloat(arc4random_uniform(UInt32(range)))
            
            Meteor.position = CGPoint(x: size.width / 2 + Meteor.size.width / 2, y: meteory)
            
            let moveLeft = SKAction.moveBy(x: -size.width - Meteor.size.width, y: 0, duration: 5)
            
            Meteor.run(SKAction.sequence([moveLeft, SKAction.removeFromParent()]))
        }
        
        func saveHighScore() {
            UserDefaults.standard.set(Score, forKey: highScoreUserDefaultKey)
            UserDefaults.standard.synchronize()
            highScoreLabel?.text = "High Score \(UserDefaults().integer(forKey: highScoreUserDefaultKey))"
        }
        func didBegin(_ contact: SKPhysicsContact) {
            
            
            
            if contact.bodyA.categoryBitMask == starCatergory {
                contact.bodyA.node?.removeFromParent()
                Score += 1
                scoreLabel?.text = "Score: \(Score)"
            }
            if contact.bodyB.categoryBitMask == starCatergory {
                contact.bodyB.node?.removeFromParent()
                Score += 1
                scoreLabel?.text = "Score: \(Score)"
            }
            
            if contact.bodyA.categoryBitMask == alienCatergory {
                contact.bodyA.node?.removeFromParent()
                gameOver()
            }
            if contact.bodyB.categoryBitMask == alienCatergory {
                contact.bodyB.node?.removeFromParent()
                gameOver()
            }
            if contact.bodyA.categoryBitMask == meteorCatergory {
                contact.bodyA.node?.removeFromParent()
                gameOver()
            }
            if contact.bodyB.categoryBitMask == meteorCatergory {
                contact.bodyB.node?.removeFromParent()
                gameOver()
            }
        }
        
        
        func gameOver() {
            if scene?.isPaused == true{
                return
            }
            scene?.isPaused = true
            
            starTimer?.invalidate()
            alienTimer?.invalidate()
            meteorTimer?.invalidate()
            
            yourScoreLabel = SKLabelNode(text: "Your Score:")
            yourScoreLabel?.position = CGPoint(x: 0, y: 200)
            yourScoreLabel?.fontSize = 100
            yourScoreLabel?.zPosition = 3
            if yourScoreLabel != nil {
                if Score > UserDefaults().integer(forKey: highScoreUserDefaultKey) {
                    addChild(yourScoreLabel!)
                    
                }
                finalScoreLabel = SKLabelNode(text: "\(Score)")
                finalScoreLabel?.position = CGPoint(x: 0, y: 0)
                finalScoreLabel?.fontSize = 200
                finalScoreLabel?.zPosition = 3
                if finalScoreLabel != nil {
                    addChild(finalScoreLabel!)
                }
                
                highScoreLabel?.text = "High Score : \(UserDefaults().integer(forKey: highScoreUserDefaultKey))"
                //            highScoreLabel?.position = CGPoint(x: 0 , y: 300)
                //            highScoreLabel?.fontSize = 100
                highScoreLabel?.zPosition = 3
                //        if highScoreLabel != nil {
                //            addChild(highScoreLabel!)
                //        }
                
                let playButton = SKSpriteNode(imageNamed: "play")
                playButton.position = CGPoint(x: 0, y: -200)
                playButton.name = "play"
                playButton.zPosition = 1
                addChild(playButton)
            }
            
        }

}
