//
//  ZAImageMaskViewController.swift
//  图片应用swift
//
//  Created by  jiangminjie on 2018/5/29.
//  Copyright © 2018年 SeaHot. All rights reserved.
//

import UIKit
import CoreImage

class ZAImageMaskViewController: UIViewController {

    var originalImage: UIImage = UIImage(named: "my")!
    
    lazy var bgImage : UIImageView = {
        let bgImage = UIImageView()
        bgImage.frame = CGRect(x: 20, y: 20, width: SCREENWIDTH-40, height: SCREENHEIGHT-NAV_HEIGHT-40)
        bgImage.image = originalImage
        bgImage.contentMode = .scaleAspectFit
        return bgImage
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.gray
        self.view.addSubview(self.bgImage)
         
        let btnWidth = (self.view.frame.size.width - 40 ) / 4
        // Do any additional setup after loading the view.
        let titleArr = ["怀旧","黑白","色调","岁月","单色","褪色","冲印","烙黄","原图","A1","A2","A3"]
        for i in 0..<titleArr.count {
            let changeBtn = UIButton()
            changeBtn.tag = 100 + i
            changeBtn.frame = CGRect(x: 20 + Int(btnWidth * CGFloat(i % 4)), y: SCREENWIDTH + 100 + Int(40 * CGFloat(i / 4)), width: Int(btnWidth)  , height: 40 )
            changeBtn.setTitle(titleArr[i], for: .normal)
            changeBtn.backgroundColor = UIColor.yellow
            changeBtn.setTitleColor(UIColor.black, for: .normal)
            changeBtn.addTarget(self, action: #selector(ZAImageMaskViewController.onAddImageFilter(changeBt:)), for: .touchUpInside)
            self.view.addSubview(changeBtn)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ZAImageMaskViewController {
    @objc func onAddImageFilter(changeBt:UIButton) {
        switch changeBt.tag-100 {
        case 0:
            self.onSelectFilterName("CIPhotoEffectInstant")
            break
        case 1:
            self.onSelectFilterName("CIPhotoEffectNoir")
            break
        case 2:
            self.onSelectFilterName("CIPhotoEffectTonal")
            break
        case 3:
            self.onSelectFilterName("CIPhotoEffectTransfer")
            break
        case 4:
            self.onSelectFilterName("CIPhotoEffectMono")
            break
        case 5:
            self.onSelectFilterName("CIPhotoEffectFade")
            break
        case 6:
            self.onSelectFilterName("CIPhotoEffectProcess")
            break
        case 7:
            self.onSelectFilterName("CIPhotoEffectChrome")
            break
        case 8:
            self.bgImage.image = self.originalImage
            break
        case 9:
            self.onSelectFilterName("CIXRay")
            break
        case 10:
            self.onSelectFilterName("CIVignetteEffect")
            break
        case 11:
            self.onSelectFilterName("CISpotLight")
            break
        default:
            break
        }
    }
    
    func onSelectFilterName(_ filterName:String) {
        DispatchQueue.global().async {
            let img = self.imageFilterHander(image: self.originalImage, filterName: filterName)
            DispatchQueue.main.async(execute: {
                self.bgImage.image = img
            })
        }
    }
    
    func imageFilterHander(image:UIImage,filterName:String) -> UIImage {
        let inputImage = CIImage(image: image)
        //设置键值,并输出图像
        let filter = CIFilter(name: filterName)
        filter?.setValue(inputImage, forKey: kCIInputImageKey)
        let outImage = filter?.outputImage

        let context = CIContext(options: nil)
        let cgImg = context.createCGImage(outImage!, from: (outImage?.extent)!)
        
        return UIImage(cgImage: cgImg!)
    }
}
