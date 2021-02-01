//
//  GameViewController.swift
//  Pop The Balloon
//
//  Created by Barak on 30/12/2020.
//

import UIKit
import SpriteKit
import GameplayKit

protocol SceneMangerDelegate {
    func presentMenuScene()
    func presentGameScene()
}

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        presentMenuScene()
    }
}

extension GameViewController: SceneMangerDelegate {
    func presentMenuScene() {
        let menuScene = MenuScene(size: view.bounds.size)
        menuScene.SceneMangerDelegate = self
        present(scene: menuScene)
    }
    
    func presentGameScene() {
        
//        let gameScene = GameScene()
        let gameScene = GameScene(size: view.bounds.size)
        gameScene.SceneMangerDelegate = self
        present(scene: gameScene)
        
    }
    
    func present(scene: SKScene) {
        if let view = self.view as! SKView? {
            scene.scaleMode = .aspectFill
//            view.showsFPS = true
            view.presentScene(scene)
//            view.ignoresSiblingOrder = true
        }
    }
}
