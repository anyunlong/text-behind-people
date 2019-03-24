//
//  WordView.swift
//  Example
//
//  Created by Yunlong An on 2019/3/20.
//  Copyright © 2019 Yunlong An. All rights reserved.
//

import UIKit

class WordView: UILabel {
    
    var move: CGFloat = 100

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        text = "我是大弹幕"
        font = UIFont.boldSystemFont(ofSize: 800)
        
        backgroundColor = UIColor.red.withAlphaComponent(0.2)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let rect = CGRect(x: move, y: 100, width: 100, height: 100)
        UIBezierPath(rect: rect).fill(with: .clear, alpha: 1)
        
        //        for subview in subviews {
        //            let rect = CGRect(x: 100, y: 100, width: 100, height: 100)
        //            UIBezierPath(rect: rect).fill(with: .clear, alpha: 1)
        //        }
    }
    
    func setNeedsDisplay(move: CGFloat) {
        self.move = move + self.move
        self.setNeedsDisplay()
    }
}
