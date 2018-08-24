//
//  GameShowScene.swift
//  flappyBird
//
//  Created by  jiangminjie on 2018/6/25.
//  Copyright © 2018年 SeaHot. All rights reserved.
//

import SpriteKit

enum GameStatus {
    case idle               //初始化
    case running            //游戏中
    case over               //结束游戏
}

struct PhysisCategery {
    static let BirdCategary:UInt32 = 0x1 << 1
    static let PipeCategary:UInt32 = 0x1 << 2
    static let FloorCategary:UInt32 = 0x1 << 3
    static let NoneCategary:UInt32 = 0
}

class GameShowScene: SKScene {
    
    var gameStatus:GameStatus = .idle
    var bird:SKSpriteNode!
    var floor1:SKSpriteNode!
    var floor2:SKSpriteNode!
    var tapNode:SKSpriteNode!
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        //小鸟
        bird = childNode(withName: "bird") as! SKSpriteNode
        bird.physicsBody = SKPhysicsBody(texture: bird.texture!, size: bird.size)
        bird.physicsBody?.affectedByGravity = false
        bird.physicsBody?.isDynamic = false     //是否受力
        bird.physicsBody?.categoryBitMask = PhysisCategery.BirdCategary
        bird.physicsBody?.contactTestBitMask = PhysisCategery.PipeCategary
        bird.physicsBody?.collisionBitMask = PhysisCategery.NoneCategary
        
        //地面1
        floor1 = childNode(withName: "floor1") as!SKSpriteNode
        floor1.physicsBody = SKPhysicsBody(edgeLoopFrom: CGRect(x: 0, y: 0, width: self.floor1.size.width, height: self.floor1.size.height))
        floor1.physicsBody?.affectedByGravity = false
        floor1.physicsBody?.categoryBitMask = PhysisCategery.FloorCategary
        floor1.physicsBody?.contactTestBitMask = PhysisCategery.BirdCategary
        floor1.physicsBody?.collisionBitMask = PhysisCategery.NoneCategary
        
        //地面1
        floor2 = childNode(withName: "floor2") as!SKSpriteNode
        floor2.physicsBody = SKPhysicsBody(edgeLoopFrom: CGRect(x: 0, y: 0, width: self.floor2.size.width, height: self.floor2.size.height))
        floor2.physicsBody?.categoryBitMask = PhysisCategery.FloorCategary
        floor2.physicsBody?.contactTestBitMask = PhysisCategery.BirdCategary
        floor2.physicsBody?.collisionBitMask = PhysisCategery.NoneCategary
        
        //挡板
        tapNode = childNode(withName: "tap") as! SKSpriteNode
        
        //初始化
        shuffle()
        
        //创建场景的物理体
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)//给场景添加一个物理体，这个物理体就是一条沿着场景四周的边，限制了游戏范围，其他物理体就不会跑出这个场景
        
        //物理世界的碰撞检测代理为场景自己，这样如果这个物理世界里面有两个可以碰撞接触的物理体碰到一起了就会通知他的代理
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVector(dx: 0.0, dy: -9.8)
    }
    
    //每帧刷新
    override func update(_ currentTime: TimeInterval) {
        if gameStatus != .over {
            //移到动画
            moveScene()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        switch gameStatus {
        case .idle:
            tapNode.isHidden = true
            tapNode.removeFromParent()
            startGame() //如果在初始化状态下，玩家点击屏幕则开始游戏
        case .running:
            print("给小鸟一个向上的力")   //如果在游戏进行中状态下，玩家点击屏幕则给小鸟一个向上的力(暂时用print一句话代替)
        case .over:
            shuffle() //如果在游戏结束状态下，玩家点击屏幕则进入初始化状态
        }
    }
}

//MARK: 方法扩展
extension GameShowScene {
    
    //游戏初始化处理方法
    func shuffle() {
        
        gameStatus = .idle
//        bird.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        
        //小鸟起飞
        birdStartFly()
        
        //清除残留水管
        removeAllPipesNode()
        
    }
    
    //游戏开始处理方法
    func startGame() {
        
        gameStatus = .running
        bird.physicsBody?.isDynamic = true
        //创建水管
        startCreateRandomPipesAction()
    }
    
    //游戏结束处理方法
    func gameOver() {
        
        gameStatus = .over
        
        //小鸟停止飞
        birdStopFly()
        
        //停止创建水管
        stopCreateRandomPipesAction()
    }

    //移到动画
    func moveScene() {
        self.floor1.position = CGPoint(x: self.floor1.position.x-10, y: self.floor1.position.y)
        self.floor2.position = CGPoint(x: self.floor2.position.x-10, y: self.floor2.position.y)
        
        if self.floor1.position.x < -self.floor1.size.width {
            self.floor1.position = CGPoint(x: self.floor2.position.x+self.floor2.size.width, y: self.floor1.position.y)
        }
        
        if self.floor2.position.x < -self.floor2.size.width {
            self.floor2.position = CGPoint(x: self.floor1.position.x+self.floor1.size.width, y: self.floor2.position.y)
        }
        
        //循环检查场景的子节点，同时这个子节点的名字要为pipe
        for pipeNode in self.children
            where pipeNode.name == "pipe" {
                //因为我们要用到水管的size，但是SKNode没有size属性，所以我们要把它转成SKSpriteNode
                if let pipeSprite = pipeNode as? SKSpriteNode {
                    //将水管左移1
//                    pipeSprite.frame = CGRect(x: pipeSprite.frame.origin.x - 10, y: pipeSprite.frame.origin.y, width: pipeSprite.frame.size.width, height: pipeSprite.frame.size.height)
                    pipeSprite.position = CGPoint(x: pipeSprite.position.x - 10, y: pipeSprite.position.y)
//                    NSLog("\(pipeSprite)")
                    //CGPoint(x: pipeSprite.position.x - 10, y: pipeSprite.position.y)

                    //检查水管是否完全超出屏幕左侧了，如果是则将它从场景里移除掉
                    if pipeSprite.position.x < -pipeSprite.size.width  {
                        pipeSprite.removeFromParent()
                    }
                }
        }
    }
    
    //小鸟起飞
    func birdStartFly() {
        let birdAction = SKAction.animate(with: [SKTexture(imageNamed: "bird0_0"),
                                SKTexture(imageNamed: "bird0_1"),
                                SKTexture(imageNamed: "bird0_2")], timePerFrame: TimeInterval(0.15))
        let actions = SKAction.repeatForever(birdAction)
        self.bird.run(actions, withKey: "fly")
    }
    
    //小鸟停止飞
    func birdStopFly() {
        self.bird.removeAction(forKey: "fly")
    }
    
    //添加水管
    func startCreateRandomPipesAction() {
        //创建一个等待的action,等待时间的平均值为3.5秒，变化范围为1秒
        let waitAct = SKAction.wait(forDuration: 3.5, withRange: 1.0)
        
        //创建一个产生随机水管的action，这个action实际上就是调用一下我们上面新添加的那个createRandomPipes()方法
        let generatePipeAct = SKAction.run {
            self.createRandomPipes()
        }

        //让场景开始重复循环执行"等待" -> "创建" -> "等待" -> "创建"。。。。。
        //并且给这个循环的动作设置了一个叫做"createPipe"的key来标识它
        run(SKAction.repeatForever(SKAction.sequence([waitAct, generatePipeAct])), withKey: "createPipe")
    }
    
    //停止创建水管
    func stopCreateRandomPipesAction() {
        self.removeAction(forKey: "createPipe")
    }
    
    //随机值
    func createRandomPipes() {
        //先计算地板顶部到屏幕顶部的总可用高度
        let height = self.size.height - self.floor1.size.height

        //计算上下管道中间的空档的随机高度，最小为空档高度为2.5倍的小鸟的高度，最大高度为3.5倍的小鸟高度
        let pipeGap = CGFloat(arc4random_uniform(UInt32(bird.size.height))) + bird.size.height * 2.5

        //管道宽度在60
        let pipeWidth = CGFloat(60.0)

        //随机计算顶部pipe的随机高度，这个高度肯定要小于(总的可用高度减去空档的高度)
        let topPipeHeight = CGFloat(arc4random_uniform(UInt32(height - pipeGap)))

        //总可用高度减去空档gap高度减去顶部水管topPipe高度剩下就为底部的bottomPipe高度
        let bottomPipeHeight = height - pipeGap - topPipeHeight
        
        //调用添加水管到场景方法
        onAddPips(topSize: CGSize(width: pipeWidth, height: topPipeHeight), bottomSize: CGSize(width: pipeWidth, height: bottomPipeHeight))
    }
    
    func onAddPips(topSize: CGSize, bottomSize: CGSize) {
        //创建上水管
        //利用上水管图片创建一个上水管纹理对象
        let topTexture = SKTexture(imageNamed: "topPipe")
        //利用上水管纹理对象和传入的上水管大小参数创建一个上水管对象
        let topPipe = SKSpriteNode(texture: topTexture, size: topSize)
        topPipe.anchorPoint = CGPoint(x: 0, y: 0)
        topPipe.zPosition = 1
        //给这个水管取个名字叫pipe
        topPipe.name = "pipe"
        //设置上水管的垂直位置为顶部贴着屏幕顶部，水平位置在屏幕右侧之外
        topPipe.position = CGPoint(x: self.size.width + topPipe.size.width * 0.5, y: self.size.height - topPipe.size.height)
        topPipe.physicsBody = SKPhysicsBody(texture: topTexture, size: topPipe.size)
        topPipe.physicsBody?.affectedByGravity = false;
//        topPipe.physicsBody?.isDynamic = true
        topPipe.physicsBody?.categoryBitMask = PhysisCategery.PipeCategary
        topPipe.physicsBody?.contactTestBitMask = PhysisCategery.BirdCategary
        topPipe.physicsBody?.collisionBitMask = PhysisCategery.NoneCategary

        //创建下水管，每一句方法都与上面创建上水管的相同意义
        let bottomTexture = SKTexture(imageNamed: "bottomPipe")
        let bottomPipe = SKSpriteNode(texture: bottomTexture, size: bottomSize)
        bottomPipe.anchorPoint = CGPoint(x: 0, y: 0)
        bottomPipe.zPosition = 1
        bottomPipe.name = "pipe"
        //设置下水管的垂直位置为底部贴着地面的顶部，水平位置在屏幕右侧之外
        bottomPipe.position = CGPoint(x: self.size.width + bottomPipe.size.width * 0.5, y: self.floor1.size.height )
        bottomPipe.physicsBody = SKPhysicsBody(texture: bottomTexture, size: bottomPipe.size)
        bottomPipe.physicsBody?.affectedByGravity = false;
        bottomPipe.physicsBody?.isDynamic = true
        bottomPipe.physicsBody?.categoryBitMask = PhysisCategery.PipeCategary
        bottomPipe.physicsBody?.contactTestBitMask = PhysisCategery.BirdCategary
        bottomPipe.physicsBody?.collisionBitMask = PhysisCategery.NoneCategary

        //将上下水管添加到场景里
        addChild(topPipe)
//        addChild(bottomPipe)
        
        NSLog("添加水管:\(NSStringFromCGPoint(topPipe.position)).\(NSStringFromCGSize(topPipe.size)) >> \(NSStringFromCGPoint(bottomPipe.position)).\(NSStringFromCGSize(bottomPipe.size))")
    }
    
    //清除残留水管
    func removeAllPipesNode(){
        //循环检查场景的子节点，同时这个子节点的名字要为pipe
        for pipe in self.children
            where pipe.name == "pipe" {
                //将水管这个节点从场景里移除掉
                pipe.removeFromParent()
            }
    }
}

//MARK: 代理
extension GameShowScene:SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        NSLog("******************")
        if (contact.bodyA.categoryBitMask == PhysisCategery.BirdCategary && contact.bodyB.categoryBitMask == PhysisCategery.PipeCategary) || (contact.bodyA.categoryBitMask == PhysisCategery.PipeCategary && contact.bodyB.categoryBitMask == PhysisCategery.BirdCategary) {
            NSLog(">>>>>>>>>>>>>>>>>>.")
            if (contact.bodyA.categoryBitMask == PhysisCategery.BirdCategary && contact.bodyB.categoryBitMask == PhysisCategery.PipeCategary) {
                let pipNode =  contact.bodyB.node as! SKSpriteNode
                let pip_minY = pipNode.position.y
//                let pip_maxY = contact.bodyB.node?.position.y+contact.bodyB.node.size
            }
            
            gameOver()
        }
    }
    
}
