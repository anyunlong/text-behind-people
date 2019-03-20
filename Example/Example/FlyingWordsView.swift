//
//  FlyingWordsView.swift
//  Example
//
//  Created by Yunlong An on 2019/3/20.
//  Copyright © 2019 Yunlong An. All rights reserved.
//

import UIKit

class FlyingWordsView: UIView {
    
    var move: CGFloat = 0
    
    lazy var label: UILabel = {
        let l = UILabel()
        l.text = "我是大弹幕"
        l.font = UIFont.boldSystemFont(ofSize: 800)
        return l
    }()
    
    lazy var wordView: WordView = {
        let w = WordView()
//        l.text = "我是大弹幕"
//        l.font = UIFont.boldSystemFont(ofSize: 800)
        return w
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.green.withAlphaComponent(0.2)
        
        addSubview(wordView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let rect = CGRect(x: 100, y: 100, width: 100, height: 100)
        UIBezierPath(rect: rect).fill(with: .clear, alpha: 1)
        
//        for subview in subviews {
//            let rect = CGRect(x: 100, y: 100, width: 100, height: 100)
//            UIBezierPath(rect: rect).fill(with: .clear, alpha: 1)
//        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let size = wordView.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude))
        wordView.frame = bounds
        wordView.frame.size.width = size.width
        wordView.frame.origin.x = move
    }
    
    func layoutIfNeeded(move: CGFloat) {
        wordView.frame.origin.x = wordView.frame.origin.x - move
        wordView.setNeedsDisplay(move: move)
    }
    
    func startFly() {
        
    }
}
