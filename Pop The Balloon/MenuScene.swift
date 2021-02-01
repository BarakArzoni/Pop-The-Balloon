//
//  MenuScene.swift
//  Pop The Balloon
//
//  Created by Barak on 17/01/2021.
//

import SpriteKit

class MenuScene: SKScene {
    
    var SceneMangerDelegate: SceneMangerDelegate?
    
    var logo: SKSpriteNode?
    var firstCloud: SKSpriteNode?
    var secondCloud: SKSpriteNode?
    var thirdCloud: SKSpriteNode?
    let highscore: Int = UserDefaults.standard.integer(forKey: "Highscore")
    let highscoreTitleLabel = SKLabelNode(text: "HIGH SCORE")
    var highscoreContentLabel: SKLabelNode?
    var playButton: PlayButton?
    
    
    
    
    override func didMove(to view: SKView) {
        setupMenu()
    }
    
    func setupMenu() {
//        let background = SKSpriteNode(imageNamed: "skyBackground.jpg")
        let background = SKSpriteNode(imageNamed: "Untitled_Artwork.png")
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        background.size = CGSize(width: frame.width, height: frame.height)
        background.zPosition = 1
        addChild(background)
        
        logo = SKSpriteNode(imageNamed: "Logo.png")
        if let logo = logo {
            let widthToScale = frame.size.width * 0.8
            let logoWidth = logo.frame.size.width
            let scale = widthToScale / logoWidth
            logo.setScale(scale)
            logo.zPosition = 3
            logo.position = CGPoint(x: frame.midX, y: frame.midY + logo.frame.size.height * 1.75)
            print("logo: \(logo.frame.size.width * 0.75)")
            addChild(logo)
        }
        
        
        let moveFast = SKAction.repeatForever(SKAction.moveBy(x: -10, y: 0, duration: 0.3))
        let moveSlow = SKAction.repeatForever(SKAction.moveBy(x: -7, y: 0, duration: 0.3))
        let moveSlower = SKAction.repeatForever(SKAction.moveBy(x: -4, y: 0, duration: 0.3))
        
        firstCloud = SKSpriteNode(imageNamed: "Small_cloud")
        if let firstCloud = firstCloud {
            firstCloud.position = CGPoint(x: frame.midX, y: frame.maxY - firstCloud.frame.height * 1.7)
            firstCloud.zPosition = 2
            firstCloud.run(moveSlow)
            firstCloud.alpha = 0.5
            addChild(firstCloud)
        }
        secondCloud = SKSpriteNode(imageNamed: "Medium_cluod")
        if let secondCloud = secondCloud {
            secondCloud.run(moveFast)
            secondCloud.position = CGPoint(x: frame.maxX + secondCloud.frame.width / 2, y: frame.midY)
            secondCloud.zPosition = 2
            secondCloud.alpha = 0.5
            addChild(secondCloud)
        }
        thirdCloud = SKSpriteNode(imageNamed: "Big_cloud")
        if let thirdCloud = thirdCloud {
            thirdCloud.run(moveSlower)
            thirdCloud.position = CGPoint(x: frame.minX - thirdCloud.frame.width/4, y: frame.minY + thirdCloud.frame.height * 1.5)
            thirdCloud.zPosition = 2
            thirdCloud.alpha = 0.5
            addChild(thirdCloud)
        }
        
        playButton = PlayButton(defaultButtonImage: "redBalloon", action: goToGameScene)
        if let button = playButton {
            button.aspectScale(to: frame.size, width: false, multiplier: 0.2)
            button.position = CGPoint(x: frame.midX, y: frame.midY)
            button.zPosition = 3
            addChild(button)
        }
        
        highscoreTitleLabel.fontName = "Baloo2-Bold"
        highscoreTitleLabel.fontSize = 35
        highscoreTitleLabel.zPosition = 3
        highscoreTitleLabel.fontColor = UIColor(red: 255, green: 255, blue: 255, alpha: 1)
        highscoreTitleLabel.position = CGPoint(x: frame.midX, y: frame.midY - logo!.frame.size.height * 1.75 + highscoreTitleLabel.frame.height)
        addChild(highscoreTitleLabel)
        
        highscoreContentLabel = SKLabelNode(text: String(highscore)) 
        if let highscoreContentLabel = highscoreContentLabel {
            highscoreContentLabel.fontName = "Baloo2-Bold"
            highscoreContentLabel.fontSize = 105
            highscoreContentLabel.zPosition = 3
            highscoreContentLabel.fontColor = UIColor(red: 255, green: 255, blue: 255, alpha: 1)
            highscoreContentLabel.position = highscoreTitleLabel.position
            highscoreContentLabel.position.y -= highscoreContentLabel.frame.height * 1.2
            addChild(highscoreContentLabel)
        }
        
        
//        let playLabel = SKLabelNode(text: "PLAY")
//        playLabel.fontName = "AvenirNext-Bold"
//        playLabel.fontSize = 50
//        playLabel.zPosition = 3
//        playLabel.fontColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
//        playLabel.position = CGPoint(x: frame.midX, y: frame.midY)
//        
//        addChild(playLabel)
        
    }
    
    func goToGameScene() {
        logo?.run(SKAction.fadeOut(withDuration: 0.3))
        firstCloud?.run(SKAction.fadeOut(withDuration: 0.3))
        secondCloud?.run(SKAction.fadeOut(withDuration: 0.3))
        thirdCloud?.run(SKAction.fadeOut(withDuration: 0.3))
        highscoreTitleLabel.run(SKAction.fadeOut(withDuration: 0.3))
        highscoreContentLabel?.run(SKAction.fadeOut(withDuration: 0.3))
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.SceneMangerDelegate?.presentGameScene()
        }
        
    }
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        if let touch = touches.first {
//            let location = touch.location(in: self)
//            if let button = playButton {
//                if button.contains(location) {
//                   
//                    logo?.run(SKAction.scale(by: 2, duration: 0.1))
//                }
//                
//            }
//        }
//    }
    
    override func update(_ currentTime: TimeInterval) {
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
