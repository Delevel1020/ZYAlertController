//
//  ViewController.swift
//  ZYAlertController
//
//  Created by Ding on 2023/3/7.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let image = UIImageView.init(image: UIImage(named: "bg"))
        image.frame = self.view.bounds
        self.view.addSubview(image)

        let button = UIButton.init(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false

//        button.frame = CGRectMake(0, 100, UIScreen.main.bounds.size.width, 100)
        button.setTitle("点击", for: .normal)
        button.setTitleColor(UIColor.red, for: .normal)
        button.addTarget(self, action: #selector(self.addaction), for: .touchUpInside)
        self.view.addSubview(button)
        

            let layoutConstraint1 = NSLayoutConstraint (item: button, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 0)
            self.view.addConstraint(layoutConstraint1)

            let layoutConstraint2 = NSLayoutConstraint (item: button, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1, constant: 0)
            self.view.addConstraint(layoutConstraint2)

            let layoutConstraint3 = NSLayoutConstraint (item: button, attribute: .left, relatedBy: .equal, toItem: self.view, attribute: .left, multiplier: 1, constant: 0)
            self.view.addConstraint(layoutConstraint3)

            let layoutConstraint4 = NSLayoutConstraint (item: button, attribute: .right, relatedBy: .equal, toItem: self.view, attribute: .right, multiplier: 1, constant: 0)
            self.view.addConstraint(layoutConstraint4)
    }
    
    @objc public func addaction() {
        let alertView = ZYAlertView(title: "温馨提示", message: "我已经远离了你的河流，绝不是疏远，因为我已是身居异土。远远地，依然听得到你翻山越岭、日夜兼程的脚步声，依然无比清晰地看得到你的那条洒满星星的清澈的河流。只要，也只有想起你——故乡，就是异域的那条河流也会洒满故乡的星星。无论醒着还是沉睡，都会重复着那个让人心旌摇曳的画面，星星都在你的河流里百媚地眨眼。因为那条洒满星星的河流途经我无猜的孩童，无知的少年，迷茫的青春，还要经过可知的未来，是不是今后还要交付给大海了呢？那样，大海的那些星星一定是故乡送给他们的馈赠，没有故乡的孕育，大海也会失去灵气，因为大海的源头就在故乡的这头……　　星星的感情，在城市里总是被耽误。是星星的感情单一，还是城市的滥情呢？如果城市是舞台，星星就不是市民，所以也不是演员。如果天空是舞台，星星就是居民，所以能成为明星。如果河流是舞台，星星就是精灵，她就是大地的灵魂。如今，爱情在城市里就是一个错误，比金钱的质量轻百倍，所以比海洛因更危险。爱情在乡村的河流里，就有了星星的光辉，成就的是海枯石烂的传奇……　　晴空万里的白昼，总爱涂脂抹粉打扮一番。这样的时候，只有清泉敢从浓妆艳抹的云端踏过，只有披着满身星星的鱼儿敢从蓝天穿过，将自满表现的太阳戏弄一番。浆洗的女人们总爱把笑声抛在河面上，拍打着棒槌当爵士乐的节拍，委婉的歌声随着幸福的河水流淌，斑斓的衣服在白云间飘舞成了彩虹。我听到了大地与天空的窃语，彻底悟出了萨顶顶唱的《万物生》里的深刻与凝重：我看见山鹰在寂寞两条鱼上飞，两条鱼儿穿过海一样咸的河水，一片河水落下来遇见人们破碎，人们在行走，身上落满山鹰的灰……　　睡得沉沉的夜，呵欠连连，漫长得没有尽头，无论夜几多的黑，可故乡的河流从也不会迷路，因为有星星这明亮的眼睛。你的人生没有迷路，你的梦没有迷失方向，你的未来总在奔跑的路上，是不是也是借了故乡河流里的星星做慧眼呢？如果河流看不到星星，那肯定会落魄的。")
//        let action = ZYAlertAction.init(title: "确定---1", statu: .nomal) { alertAction in
//
//        }
//        let action1 = ZYAlertAction.init(title: "确定----2", statu: .nomal) { alertAction in
//
//        }
//        let action2 = ZYAlertAction.init(title: "确定----3", statu: .nomal) { alertAction in
//
//        }
        let action3 = ZYAlertAction.init(title: "我知道了", statu: .ok) { alertAction in
            
        }
//        alertView.addAction(action: action)
//        alertView.addAction(action: action1)
//        alertView.addAction(action: action2)
        alertView.addAction(action: action3)
        alertView.clipsToBounds = true
        alertView.layer.cornerRadius = 12
        alertView.buttonHorizontal = false
        let alertController = ZYAlertController(alertView: alertView, style: .alert, animation: .fade)
        alertController.blureEffectViewStyle(view: self.view, style: .light)
        alertController.backgoundTapDismissEnable = true
        self.present(alertController, animated: true, completion: nil)
    }
}

