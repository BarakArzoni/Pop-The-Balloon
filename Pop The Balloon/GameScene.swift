//
//  GameScene.swift
//  Pop The Balloon
//
//  Created by Barak on 30/12/2020.
//


import SpriteKit

class GameScene: SKScene {
    
    var SceneMangerDelegate: SceneMangerDelegate?
    
    let balloonsArr = ["yellow", "blue", "green", "purple", "red"]
    
    
    var backgroundImage: SKSpriteNode?
    let scoreLabel = SKLabelNode(text: "0")
    var isGameover = false
    var firstCloud: SKSpriteNode?
    var secondCloud: SKSpriteNode?
    var thirdCloud: SKSpriteNode?
    var restartButton: SKSpriteNode?
    let highScore = UserDefaults.standard.integer(forKey: "Highscore")
    
    
    
    var score: Int = 0 {
        didSet {
            updateScoreLabel()
            if score % 3 == 0 && score < 60 {
                physicsWorld.gravity.dy += 0.1
            }
            if score > 6 && score % 2 == 0  {
            spawnBalloons()
            }
        }
    }
    var redCounter = 0 {
        didSet {
            if redCounter < 1 {
                spawnBalloons()
            }
            
        }
    }
    var balloonsInScene = [SKSpriteNode]()
    let yellowBalloon = SKTexture(imageNamed: "yellowBalloon")
    let blueBalloon = SKTexture(imageNamed: "blueBalloon")
    let greenBalloon = SKTexture(imageNamed: "greenBalloon")
    let purpleBalloon = SKTexture(imageNamed: "purpleBalloon")
    let redBalloon = SKTexture(imageNamed: "redBalloon")
    
    var balloonsNodes = [Balloon(type: "yellow"), Balloon(type: "blue"), Balloon(type: "green"), Balloon(type: "purple"), Balloon(type: "red")]
    
    override func didMove(to view: SKView) {
        layoutScene()
        setupPhysics()
    }
    
    func layoutScene() {
//        let background = SKSpriteNode(imageNamed: "skyBackground.jpg")
        let background = SKSpriteNode(imageNamed: "Untitled_Artwork.png")
        background.size = CGSize(width: frame.width, height: frame.height)
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        background.zPosition = 1
        addChild(background)
        scoreLabel.fontName = "Baloo2-Bold"
        scoreLabel.fontSize = 60
        scoreLabel.zPosition = 2
        scoreLabel.fontColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        scoreLabel.position = CGPoint(x: frame.minX + scoreLabel.frame.size.width * 1.5, y: frame.maxY - scoreLabel.frame.size.height * 2)
        scoreLabel.alpha = 0
        scoreLabel.run(SKAction.fadeIn(withDuration: 0.3))
        addChild(scoreLabel)
        setupClouds()
        spawnBalloons()
        let firstGameInstruction = SKLabelNode(text: "POP ONLY THE")
        firstGameInstruction.fontName = "Baloo2-Bold"
        firstGameInstruction.zPosition = 2
        firstGameInstruction.fontSize = 30
        firstGameInstruction.fontColor = UIColor.white
        firstGameInstruction.alpha = 0
        firstGameInstruction.position = CGPoint(x: frame.midX, y: frame.midY)
        let secondGameInstruction = SKLabelNode(text: "RED BALLOONS")
        secondGameInstruction.fontName = "Baloo2-ExtraBold"
        secondGameInstruction.zPosition = 2
        secondGameInstruction.fontSize = 35
        secondGameInstruction.fontColor = UIColor(red: 255/255, green: 56/255, blue: 23/255, alpha: 1)
        secondGameInstruction.alpha = 0
        secondGameInstruction.position = CGPoint(x: frame.midX, y: frame.midY - firstGameInstruction.frame.height * 1.5)
        secondGameInstruction.addStroke(color: UIColor.white, width: 4)
        let fadeOut = SKAction.fadeOut(withDuration: 0.3)
        let fadeIn = SKAction.fadeIn(withDuration: 0.3)
        let removeNode = SKAction.removeFromParent()
//        firstGameInstruction.run(SKAction.sequence([fadeOut, removeNode]))
//        secondGameInstruction.run(SKAction.sequence([fadeOut, removeNode]))
        firstGameInstruction.run(fadeIn)
        secondGameInstruction.run(fadeIn)
        
        addChild(firstGameInstruction)
        addChild(secondGameInstruction)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            firstGameInstruction.run(SKAction.sequence([fadeOut, removeNode]))
            secondGameInstruction.run(SKAction.sequence([fadeOut, removeNode]))
        }
        
        
    }
    
    func spawnBalloons() {
        let screenWidth = frame.maxX - frame.minX
        let column = screenWidth / 4
        if score == 0 {
            let balloon = balloonsNodes[4].copy() as! Balloon
            
            balloon.position = CGPoint(x: frame.midX, y: frame.minY - balloon.frame.size.height / 2)
//            balloon.position = CGPoint(x: frame.midX, y: frame.midY + balloon.frame.height * 4)
            balloon.physicsBody = SKPhysicsBody(texture: balloon.texture!, size: balloon.texture!.size())
            balloon.physicsBody?.collisionBitMask = 0
            addChild(balloon)
            balloonsInScene.append(balloon)
            redCounter += 1
        } else if score >= 1 {
            var redCounter = 0
            
            var loopCounter = 0
            _ = Timer.scheduledTimer(withTimeInterval: 0.35, repeats: true){ t in
                let balloon: Balloon
                if randomBool(odds: 2) || redCounter == 0 && loopCounter == 3 {
                    balloon = self.balloonsNodes[4].copy() as! Balloon
                    redCounter += 1
                    self.redCounter += 1

                } else {
                    balloon = self.balloonsNodes[Int.random(in: 0..<4)].copy() as! Balloon
                }
                balloon.physicsBody = SKPhysicsBody(texture: balloon.texture!, size: balloon.texture!.size())
                balloon.physicsBody?.collisionBitMask = 0
                let randomLocation = Int.random(in: Int(self.frame.minX + CGFloat(loopCounter) * column + balloon.frame.size.width / 2)..<Int(self.frame.minX + CGFloat(loopCounter + 1) * column - balloon.frame.size.width / 2))
                balloon.position = CGPoint(x: CGFloat(randomLocation), y: self.frame.minY - balloon.frame.size.height / 2 - CGFloat(Int.random(in: 0...500)))
                balloon.physicsBody?.velocity = CGVector(dx: 0, dy: Int.random(in: 25..<50))
                self.addChild(balloon)
                self.balloonsInScene.append(balloon)
                loopCounter += 1
                if loopCounter >= 4 {
                    t.invalidate()
                }
            }
        }
    }
    
    func setupPhysics() {
        physicsWorld.gravity = CGVector(dx: 0.0, dy: 0.25)
    }
    
    func setupClouds() {
        let moveFast = SKAction.repeatForever(SKAction.moveBy(x: -10, y: 0, duration: 0.3))
        let moveSlow = SKAction.repeatForever(SKAction.moveBy(x: -7, y: 0, duration: 0.3))
        let moveSlower = SKAction.repeatForever(SKAction.moveBy(x: -4, y: 0, duration: 0.3))
        firstCloud = SKSpriteNode(imageNamed: "Small_cloud")
        if let firstCloud = firstCloud {
            firstCloud.alpha = 0
            firstCloud.position = CGPoint(x: frame.midX, y: frame.maxY - firstCloud.frame.height * 1.7)
            firstCloud.zPosition = 2
            firstCloud.run(moveSlow)
            firstCloud.run(SKAction.fadeAlpha(to: 0.5, duration: 0.3))
            addChild(firstCloud)
        }
        secondCloud = SKSpriteNode(imageNamed: "Medium_cluod")
        if let secondCloud = secondCloud {
            secondCloud.alpha = 0
            secondCloud.run(moveFast)
            secondCloud.position = CGPoint(x: frame.maxX + secondCloud.frame.width / 2, y: frame.midY)
            secondCloud.zPosition = 2
            secondCloud.run(SKAction.fadeAlpha(to: 0.5, duration: 0.3))
            addChild(secondCloud)
        }
        thirdCloud = SKSpriteNode(imageNamed: "Big_cloud")
        if let thirdCloud = thirdCloud {
            thirdCloud.alpha = 0
            thirdCloud.run(moveSlower)
            thirdCloud.position = CGPoint(x: frame.minX - thirdCloud.frame.width/4, y: frame.minY + thirdCloud.frame.height * 1.5)
            thirdCloud.zPosition = 2
            thirdCloud.run(SKAction.fadeAlpha(to: 0.5, duration: 0.3))
            addChild(thirdCloud)
        }
    }
    
    func gameOver() {
        isGameover = true
        for balloon in balloonsInScene {
            balloon.physicsBody?.isDynamic = false
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                balloon.removeAllActions()
            }
        }
        print("Game over! score: \(score)")
        if score > UserDefaults.standard.integer(forKey: "Highscore") {
            UserDefaults.standard.set(score, forKey: "Highscore")
            scoreLabel.color = UIColor.red
        }
        
        let highscoreTitleLabel = SKLabelNode(text: "HIGH SCORE")
        highscoreTitleLabel.fontName = "Baloo2-Bold"
        highscoreTitleLabel.fontSize = 25
        highscoreTitleLabel.alpha = 0
        highscoreTitleLabel.zPosition = 5
        highscoreTitleLabel.fontColor = UIColor(red: 255, green: 255, blue: 255, alpha: 1)
        highscoreTitleLabel.position = CGPoint(x: frame.midX, y: frame.midY - highscoreTitleLabel.frame.height * 6)
        highscoreTitleLabel.run(SKAction.fadeIn(withDuration: 0.25))
        addChild(highscoreTitleLabel)
        
        let highscoreContentLabel = SKLabelNode(text: String(highScore))
        highscoreContentLabel.fontName = "Baloo2-Bold"
        highscoreContentLabel.fontSize = 55
        highscoreContentLabel.alpha = 0
        highscoreContentLabel.zPosition = 3
        highscoreContentLabel.fontColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        highscoreContentLabel.position = highscoreTitleLabel.position
        highscoreContentLabel.position.y -= highscoreContentLabel.frame.height * 1.2
        highscoreContentLabel.run(SKAction.fadeIn(withDuration: 0.25))
        addChild(highscoreContentLabel)
        
        scoreLabel.run(SKAction.move(to: CGPoint(x: frame.midX, y: frame.midY + highscoreTitleLabel.frame.height * 6), duration: 0.25))
        scoreLabel.run(SKAction.scale(by: 2, duration: 0.25))
        scoreLabel.zPosition = 5
        restartButton = SKSpriteNode(imageNamed: "restart")
        if let restartButton = restartButton {
            restartButton.alpha = 0
            restartButton.zPosition = 5
            restartButton.size = CGSize(width: 50, height: 50)
            restartButton.position = CGPoint(x: frame.midX, y: frame.midY)
            restartButton.run(SKAction.fadeIn(withDuration: 0.25))
            addChild(restartButton)
        }
        
        
        
        
        
    }
    
    func updateScoreLabel() {
        scoreLabel.text = "\(score)"
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !isGameover {
            if let touch = touches.first {
                let location = touch.location(in: self)
                var i = 0
                var balloonsToPop = [SKSpriteNode]()
                var didPopRed = false
                
                for balloon in balloonsInScene {
                    if balloon.contains(location) {
                        let fade: SKAction
                        let removeBalloon: SKAction
                        let popFrames: [SKTexture]
                        let scale = SKAction.scale(to: 1.3, duration: 0.09)
                        
                        switch balloon.name {
                        case "red":
                            fade = SKAction.fadeOut(withDuration: 0.15)
                            popFrames = [SKTexture(imageNamed: "red1"), SKTexture(imageNamed: "red2")]
                            removeBalloon = SKAction.removeFromParent()
                            self.score += 1
                            self.redCounter -= 1
                            didPopRed = true
                            i = balloonsInScene.firstIndex(of: balloon)!
                            balloonsInScene.remove(at: i)
                            let pop = SKAction.animate(with: popFrames, timePerFrame: 0.05)
                            let group = SKAction.group([fade, pop, scale])
                            balloon.run(SKAction.sequence([group, removeBalloon]))
                        default:
                            balloonsToPop.append(balloon)
                        }
                        
                    }
                }
                if !didPopRed {
                    if let balloonName = balloonsToPop.last?.name {
                        let popFrames = [SKTexture(imageNamed: "\(balloonName)1")]
                        let pop = SKAction.animate(with: popFrames, timePerFrame: 0.05)
                        let scale = SKAction.scale(to: 1.3, duration: 0.09)
                        balloonsToPop.last?.run(scale)
                        balloonsToPop.last?.run(pop)
                        
                        gameOver()
                    }

                }
            }
        } else {
            if let touch = touches.first {
                let location = touch.location(in: self)
                if restartButton!.contains(location) {
                    self.SceneMangerDelegate?.presentGameScene()
                }
            }
        }
        
    }
    
    override func update(_ currentTime: CFTimeInterval) {
        if !isGameover {
            for balloon in balloonsInScene {
                if balloon.position.y > frame.maxY - 20 {
                    switch balloon.name {
                    case "red":
                        balloon.run(SKAction.scale(by: 1.3, duration: 0.05))
                        self.gameOver()
                        
                        
                    default:
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            balloon.removeFromParent()
                        }
                    }
                }
            }
            
        }
        
        if isGameover {
            for balloon in balloonsInScene {
                balloon.physicsBody?.isDynamic = false
                balloon.isUserInteractionEnabled = true
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                    balloon.removeAllActions()
                }
            }
            
            
        }
        if (firstCloud?.position.x)! < frame.minX - (firstCloud?.frame.size.width)! / 2 {
            firstCloud?.position.x = frame.maxX + firstCloud!.frame.size.width / 2 + 20
        }
        
        if (secondCloud?.position.x)! < frame.minX - (secondCloud?.frame.size.width)! / 2 {
            secondCloud?.position.x = frame.maxX + secondCloud!.frame.size.width / 2 + 30
        }
        
        if (thirdCloud?.position.x)! < frame.minX - (thirdCloud?.frame.size.width)! / 2 {
            thirdCloud?.position.x = frame.maxX + thirdCloud!.frame.size.width / 2 + 10
        }
        
    }
    
}

extension SKLabelNode {

   func addStroke(color:UIColor, width: CGFloat) {

        guard let labelText = self.text else { return }

        let font = UIFont(name: self.fontName!, size: self.fontSize)

        let attributedString:NSMutableAttributedString
        if let labelAttributedText = self.attributedText {
            attributedString = NSMutableAttributedString(attributedString: labelAttributedText)
        } else {
            attributedString = NSMutableAttributedString(string: labelText)
        }

    let attributes:[NSAttributedString.Key:Any] = [.strokeColor: color, .strokeWidth: -width, .font: font!, .foregroundColor: self.fontColor!]
        attributedString.addAttributes(attributes, range: NSMakeRange(0, attributedString.length))

        self.attributedText = attributedString
   }
}

