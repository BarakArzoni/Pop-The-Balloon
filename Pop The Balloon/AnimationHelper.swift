//
//  AnimationHelper.swift
//  Pop The Balloon
//
//  Created by Barak on 30/12/2020.
//

import SpriteKit

class AnimationHelper {
    static func loadTextures(from atlas: SKTextureAtlas, withName name: String) -> [SKTexture] {
        var textures = [SKTexture]()
        for index in 0..<atlas.textureNames.count {
            let textureName = name + String(index+1)
            textures.append(atlas.textureNamed(textureName))
        }
        
        return textures
    }
}
