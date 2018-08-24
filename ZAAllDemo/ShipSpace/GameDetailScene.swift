//
//  GameDetailScene.swift
//  ShipSpace
//
//  Created by  jiangminjie on 2018/6/22.
//  Copyright © 2018年 iFiero. All rights reserved.
//

import SpriteKit
import CoreMotion
import CoreGraphics

struct PhysicsCategery {
    static let ShipSpace:UInt32 = 0x1 << 1 //飞船
    static let Alien:UInt32 = 0x1 << 2     //子弹
    static let NPCs:UInt32 = 0x1 << 3      //NPC
    static let None:UInt32 = 0
}

class GameDetailScene: SKScene {

    var shipSpaceNode:SKSpriteNode!
    var motionManager:CMMotionManager!
    var xMotionPoint:CGFloat = 0
    var yMotionPoint:CGFloat = 0
    var bgNode1:SKSpriteNode!
    var bgNode2:SKSpriteNode!
    
    var lastUpdateTimeInterval:TimeInterval = 0
    var deltaTime:TimeInterval = 0
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        //设置边界
//        self.physicsBody = SKPhysicsBody(edgeLoopFrom: CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.size.width, height: self.size.height))
        
        //背景
        bgNode1 = childNode(withName: "BG1") as! SKSpriteNode
        bgNode2 = childNode(withName: "BG2") as! SKSpriteNode
        
        //飞船属性设置
        shipSpaceNode = childNode(withName: "spaceShip") as! SKSpriteNode
        shipSpaceNode.physicsBody = SKPhysicsBody(circleOfRadius: shipSpaceNode.size.width/2)
        shipSpaceNode.physicsBody?.affectedByGravity = false
        shipSpaceNode.physicsBody?.isDynamic = true
        shipSpaceNode.physicsBody?.categoryBitMask = PhysicsCategery.ShipSpace
        shipSpaceNode.physicsBody?.contactTestBitMask = PhysicsCategery.NPCs
        shipSpaceNode.physicsBody?.collisionBitMask = PhysicsCategery.None
        shipSpaceNode.physicsBody?.friction = 0.0
        shipSpaceNode.physicsBody?.mass = 0.02
        
        //设备重力加速度管理器
        motionManager = CMMotionManager()
        motionManager.accelerometerUpdateInterval = 0.2 //刷新频次
        motionManager.startAccelerometerUpdates(to: OperationQueue.current!) { (data, error) in
            guard let accelerData = data else {
                return
            }

            self.xMotionPoint = CGFloat(accelerData.acceleration.x) * 0.75 + self.xMotionPoint * 0.5
            self.yMotionPoint = CGFloat(accelerData.acceleration.y) * 0.75 + self.yMotionPoint * 0.5
        }
        
        //碰撞管理
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVector(dx: 0.0, dy: -9.8)
        
        //NPC计时器创建
        Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(GameDetailScene.onCreateNPCForGame), userInfo: nil, repeats: true)
    }
    
    //屏幕频繁刷新
    override func didSimulatePhysics() {
        
        self.shipSpaceNode.position.x += self.xMotionPoint * 50
        self.shipSpaceNode.position.y += self.yMotionPoint * 50
        
        if self.shipSpaceNode.position.x < -self.frame.width/2 + self.shipSpaceNode.frame.width {
            self.shipSpaceNode.position.x = -self.frame.width/2 + self.shipSpaceNode.frame.width
        }
        if self.shipSpaceNode.position.x > self.frame.width/2 - self.shipSpaceNode.frame.width {
            self.shipSpaceNode.position.x = self.frame.width/2 - self.shipSpaceNode.frame.width
        }
        if self.shipSpaceNode.position.y < -self.frame.height/2 + self.shipSpaceNode.frame.height/2 {
            self.shipSpaceNode.position.y = -self.frame.height/2 + self.shipSpaceNode.frame.height/2
        }
        if self.shipSpaceNode.position.y > self.frame.height/2 - self.shipSpaceNode.frame.height/2 {
            self.shipSpaceNode.position.y = self.frame.height/2 - self.shipSpaceNode.frame.height/2
        }
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        
        if lastUpdateTimeInterval == 0 {
            lastUpdateTimeInterval = currentTime
        }
        
        deltaTime = currentTime - lastUpdateTimeInterval
        lastUpdateTimeInterval = currentTime
        onUpdateBackGround(delTime: deltaTime)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let _ = touches.first else {
            return
        }
        onSendBulletForShipSpace()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let _ = touches.first else {
            return
        }
        onSendBulletForShipSpace()
    }
    
}

//MARK: Actions
extension GameDetailScene {
    func onSendBulletForShipSpace() {
        //创建子弹
        let bulletNode = SKSpriteNode(imageNamed: "BulletBlue")
        bulletNode.position = CGPoint(x: self.shipSpaceNode.position.x, y: self.shipSpaceNode.position.y+self.shipSpaceNode.frame.height/2)
        bulletNode.zPosition = 1
//        bulletNode.color = UIColor.red
        bulletNode.physicsBody = SKPhysicsBody(circleOfRadius: bulletNode.size.width/2)
        bulletNode.physicsBody?.affectedByGravity = false
        bulletNode.physicsBody?.categoryBitMask = PhysicsCategery.Alien
        bulletNode.physicsBody?.contactTestBitMask = PhysicsCategery.NPCs
        bulletNode.physicsBody?.collisionBitMask = PhysicsCategery.None
        bulletNode.physicsBody?.usesPreciseCollisionDetection = true
        addChild(bulletNode)

        //特效
        let newNode = SKNode()
        newNode.name = "特效"
        newNode.zPosition = bulletNode.zPosition
        self.addChild(newNode)
        
        let emitterNode = SKEmitterNode(fileNamed: "ShootTrailBlue")!
        emitterNode.targetNode = newNode
        bulletNode.addChild(emitterNode)
        
        //声音
        let musicNode = SKAction.playSoundFileNamed("torpedo.mp3", waitForCompletion: false)
        self.run(musicNode)
        
        //动画
        bulletNode.run(SKAction.sequence([
            SKAction.move(to: CGPoint(x: bulletNode.position.x, y: self.frame.height), duration: TimeInterval(2)),
            SKAction.run({
                newNode.removeAllChildren()
                bulletNode.removeFromParent()
            })
            ]))
    }
    
    @objc func onCreateNPCForGame() {
        //生成npc怪物
        let index_npc = Int(arc4random()%2) + 1
        let npcName = "Enemy0\(index_npc)"
        let viewWidth:CGFloat = self.frame.width
        let xNPCPoint:CGFloat = CGFloat(Float(arc4random()) / 0xFFFFFFFF) * (viewWidth/2-self.shipSpaceNode.frame.width-(-viewWidth/2+self.shipSpaceNode.frame.width)) + (-viewWidth/2+self.shipSpaceNode.frame.width)
        let yNPCPoint:CGFloat = CGFloat(self.frame.size.height/2)
        let NPCDuration:CGFloat = CGFloat(Float(arc4random()) / 0xFFFFFFFF) * (5-1.5) + 1.5
        
        let npcNode = SKSpriteNode(imageNamed: npcName)
        npcNode.position = CGPoint(x: xNPCPoint, y: yNPCPoint)
        npcNode.zPosition = 1
        npcNode.physicsBody = SKPhysicsBody(circleOfRadius: npcNode.frame.width/2)
        npcNode.physicsBody?.affectedByGravity = false
        npcNode.physicsBody?.categoryBitMask = PhysicsCategery.NPCs
        npcNode.physicsBody?.contactTestBitMask = PhysicsCategery.Alien | PhysicsCategery.ShipSpace
        npcNode.physicsBody?.collisionBitMask = PhysicsCategery.None
        addChild(npcNode)
        npcNode.run(SKAction.sequence([
            SKAction.move(to: CGPoint(x: xNPCPoint, y: -yNPCPoint), duration: TimeInterval(NPCDuration)),
            SKAction.run({
                npcNode.removeFromParent()
            })
            ]))
    }

    func onUpdateBackGround(delTime:TimeInterval) {
        NSLog("time:>>\(deltaTime)")
        bgNode1.position.y -= CGFloat(deltaTime*300)
        bgNode2.position.y -= CGFloat(deltaTime*300)
        
        if bgNode1.position.y < -bgNode1.size.height {
            bgNode1.position.y = bgNode2.position.y+bgNode2.size.height
        }
        
        if bgNode2.position.y < -bgNode2.size.height {
            bgNode2.position.y = bgNode1.position.y+bgNode1.size.height
        }
    }
}

extension GameDetailScene:SKPhysicsContactDelegate {
    public func didBegin(_ contact: SKPhysicsContact) {
     
        //npc VS alien
        if (contact.bodyA.categoryBitMask == PhysicsCategery.NPCs &&  contact.bodyB.categoryBitMask == PhysicsCategery.Alien) || (contact.bodyA.categoryBitMask == PhysicsCategery.Alien &&  contact.bodyB.categoryBitMask == PhysicsCategery.NPCs) {
            onNpcWithAlienAction(nodaA: contact.bodyA.node as! SKSpriteNode, nodeB: contact.bodyB.node as! SKSpriteNode)
        }
        //npc VS shipSpace
        else if (contact.bodyA.categoryBitMask == PhysicsCategery.NPCs &&  contact.bodyB.categoryBitMask == PhysicsCategery.ShipSpace) || (contact.bodyA.categoryBitMask == PhysicsCategery.ShipSpace &&  contact.bodyB.categoryBitMask == PhysicsCategery.NPCs) {
            onNpcWithShipSpaceAction(nodaA: contact.bodyA.node as! SKSpriteNode, nodeB: contact.bodyB.node as! SKSpriteNode)
        }
        
    }
    
    //npc VS alien
    func onNpcWithAlienAction(nodaA:SKSpriteNode,nodeB:SKSpriteNode) {
        let emitterNode = SKEmitterNode(fileNamed: "ExplosionBlue")!
        emitterNode.position = nodaA.position
        emitterNode.zPosition = 2
        self.addChild(emitterNode)
        
        let musicNode = SKAction.playSoundFileNamed("", waitForCompletion: false)
        self.run(musicNode)
        
        if nodaA.physicsBody?.categoryBitMask == PhysicsCategery.NPCs {
            nodaA.removeFromParent()
            nodeB.removeAllChildren()
            nodeB.isHidden = true
            nodeB.physicsBody?.categoryBitMask = 0
        } else {
            nodaA.removeAllChildren()
            nodaA.isHidden = true
            nodaA.physicsBody?.categoryBitMask = 0
            nodeB.removeFromParent()
        }
    }
    
    //npc VS shipSpace
    func onNpcWithShipSpaceAction(nodaA:SKSpriteNode,nodeB:SKSpriteNode) {
        
        if (nodaA.physicsBody?.categoryBitMask == PhysicsCategery.NPCs && nodeB.physicsBody?.categoryBitMask == PhysicsCategery.ShipSpace) ||
            (nodaA.physicsBody?.categoryBitMask == PhysicsCategery.ShipSpace && nodeB.physicsBody?.categoryBitMask == PhysicsCategery.NPCs){
            
            //特效
            let emitterNode = SKEmitterNode(fileNamed: "Explosion")!
            emitterNode.position = nodaA.position
            emitterNode.zPosition = 2
            self.addChild(emitterNode)
            
            
            nodaA.removeFromParent()
            nodeB.removeFromParent()
            
            //声音
            let musicNode = SKAction.playSoundFileNamed("", waitForCompletion: false)
            self.run(SKAction.sequence([
                musicNode,
                SKAction.wait(forDuration: TimeInterval(0.5)),
                SKAction.run({
                    let transition = SKTransition.doorsOpenHorizontal(withDuration: TimeInterval(0.5))
                    let gameScene = LoseScene(fileNamed: "LoseScene")!
                    gameScene.size = self.size
                    gameScene.scaleMode = .aspectFill
                    self.view?.presentScene(gameScene, transition: transition)
                })
                ]))
        }
    }
}
