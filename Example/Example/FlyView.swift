//
//  FlyView.swift
//  Example
//
//  Created by Yunlong An on 2019/3/25.
//  Copyright © 2019 Yunlong An. All rights reserved.
//

import UIKit

class FlyView: UIView {
    
    lazy private var timer = {
        return Timer(timeInterval: 0.1, repeats: true, block: { (_) in
            self.flyOne()
        })
    }()
    
    private let dataSource = ["真香😁",
                              "高产似母猪",
                              "无中生友😂",
                              "我有一个大胆的想法😏",
                              "nmsl",
                              "两开花",
                              "又莱了🐒",
                              "这个不辣🌶️"]

    func startFly() {
        RunLoop.main.add(timer, forMode: .default)
    }
    
    private func flyOne() {
        
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.text = dataSource[Int.random(in: 0 ..< dataSource.count)]
        label.textColor = UIColor.random
        label.sizeToFit()
        
        addSubview(label)
        let y = CGFloat.random(in: 0 ... (frame.height - label.frame.height))
        label.frame.origin = CGPoint(x: frame.width, y: y)
        
        UIView.animate(withDuration: 5, animations: {
            label.frame.origin.x = -label.frame.size.width
        }, completion: { _ in
            label.removeFromSuperview()
        })
    }
}
