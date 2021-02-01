//
//  PlayButton.swift
//  Pop The Balloon
//
//  Created by Barak on 17/01/2021.
//

import SpriteKit

class PlayButton: SKSpriteNode {
    
    var defaultButton: SKSpriteNode
    let playLabel = SKLabelNode(text: "PLAY")
    
    var action: () -> ()
    
    init(defaultButtonImage: String, action: @escaping () -> ()) { //, cloud: CGPoint
        defaultButton = SKSpriteNode(imageNamed: defaultButtonImage)
        self.action = action
//        self.cloud = cloud
        super.init(texture: nil, color: UIColor.clear, size: defaultButton.size)
        isUserInteractionEnabled = true
        let rotateRight = SKAction.sequence([SKAction.rotate(byAngle: CGFloat.pi / 25 , duration: 1), SKAction.rotate(byAngle: -CGFloat.pi / 25, duration: 0.7)])
        let rotateLeft = SKAction.sequence([SKAction.rotate(byAngle: -CGFloat.pi / 25 , duration: 1), SKAction.rotate(byAngle: CGFloat.pi / 25, duration: 0.7)])
        defaultButton.run(SKAction.repeatForever(SKAction.sequence([rotateRight, rotateLeft])))
        addChild(defaultButton)
        playLabel.fontName = "Baloo2-Bold"
        playLabel.fontSize = 70
        playLabel.zPosition = 4
        playLabel.fontColor = UIColor(red: 255, green: 255, blue: 255, alpha: 1)
        addChild(playLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            if defaultButton.contains(location) {
                let scale = SKAction.scale(to: 1.3, duration: 0.09)
                let fade = SKAction.fadeOut(withDuration: 0.15)
                let popFrames = [SKTexture(imageNamed: "red1"), SKTexture(imageNamed: "red2")]
                let pop = SKAction.animate(with: popFrames, timePerFrame: 0.05)
                let group = SKAction.group([fade, pop, scale])
                defaultButton.run(group)
                playLabel.run(SKAction.fadeOut(withDuration: 0.1))
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    self.action()
                }
                
            }
        }
    }

    func aspectScale(to size: CGSize, width: Bool, multiplier: CGFloat) {
        let scale = width ? (size.width * multiplier) / self.frame.size.width : (size.height * multiplier) / self.frame.size.height
        self.setScale(scale)
    }
}
