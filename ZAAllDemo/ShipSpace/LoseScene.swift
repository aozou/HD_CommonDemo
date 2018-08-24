//
//  LoseScene.swift
//  ShipSpace
//
//  Created by  jiangminjie on 2018/6/25.
//  Copyright © 2018年 iFiero. All rights reserved.
//

import SpriteKit

class LoseScene: SKScene {

    var playNode:SKSpriteNode!
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        playNode = childNode(withName: "play") as! SKSpriteNode
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let firstTouch = touches.first else {
            return
        }
        
        let locationPoint = firstTouch.location(in: self)
        if playNode.contains(locationPoint) {
            let transition = SKTransition.doorsOpenVertical(withDuration: TimeInterval(0.5))
            let gameScene = GameDetailScene(fileNamed: "GameDetailScene")!
            gameScene.size = self.size
            gameScene.scaleMode = .aspectFill
            self.view?.presentScene(gameScene, transition: transition)
        }
    }
    
}
