//
//  GameMainScene.swift
//  ShipSpace
//
//  Created by  jiangminjie on 2018/6/22.
//  Copyright © 2018年 iFiero. All rights reserved.
//

import SpriteKit

class GameMainScene: SKScene {
    
    var playNode:SKSpriteNode!
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        playNode = childNode(withName: "play") as! SKSpriteNode
        
        let musicNode = SKAudioNode(fileNamed: "spaceBattle.mp3")
        musicNode.autoplayLooped = true
        addChild(musicNode)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        
        guard self.playNode != nil else {
            return
        }
        
        let touchPoint = touch.location(in: self)
        if self.playNode.contains(touchPoint) {
            let transition = SKTransition.doorsOpenVertical(withDuration: TimeInterval(0.5))
            let gameScene = GameDetailScene(fileNamed: "GameDetailScene")!
            gameScene.size = self.size
            gameScene.scaleMode = .aspectFill
            self.view?.presentScene(gameScene, transition: transition)
        }
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
}
