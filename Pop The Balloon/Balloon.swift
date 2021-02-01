//
//  Balloon.swift
//  Pop The Balloon
//
//  Created by Barak on 11/01/2021.
//

import SpriteKit

class Balloon: SKSpriteNode {
    
    let balloonType: String
    
    let rotateRight = SKAction.sequence([SKAction.rotate(byAngle: CGFloat.pi / 25 , duration: 0.7), SKAction.rotate(byAngle: -CGFloat.pi / 25, duration: 0.7)])
    let rotateLeft = SKAction.sequence([SKAction.rotate(byAngle: -CGFloat.pi / 25 , duration: 0.7), SKAction.rotate(byAngle: CGFloat.pi / 25, duration: 0.7)])
    
    
    
    init(type: String) {
        balloonType = type
        let texture = SKTexture(imageNamed: "\(type)Balloon")
        
        
        super.init(texture: texture, color: UIColor.clear, size: CGSize(width: 55, height: 70))
        if balloonType == "red" {
            self.zPosition = 4
        } else {
            self.zPosition = 3
        }
//        self.physicsBody?.collisionBitMask = 0
        
        if randomBool(odds: 2) {
            self.run(SKAction.repeatForever(SKAction.sequence([rotateRight, rotateLeft])))
        } else {
            self.run(SKAction.repeatForever(SKAction.sequence([rotateLeft, rotateRight])))
        }
        self.name = type
    }
    
    override func copy(with zone: NSZone? = nil) -> Any {
            let copy = Balloon(type: balloonType)
            return copy
        }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
