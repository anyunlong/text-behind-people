//
//  ViewController.swift
//  Example
//
//  Created by Yunlong An on 2019/3/20.
//  Copyright © 2019 Yunlong An. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var flyingWordsView: FlyingWordsView?
    var displayCount: CGFloat = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        CADisplayLink(target: self, selector: #selector(displayLinkCallback)).add(to: RunLoop.main, forMode: .default)
        
        flyingWordsView = FlyingWordsView(frame: CGRect.zero)
        view.addSubview(flyingWordsView ?? UIView())
        
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        button.backgroundColor = UIColor.red
        button.addTarget(self, action: #selector(test), for: .touchUpInside)
        view.addSubview(button)
    }
    
    @objc func displayLinkCallback() {
//        if displayCount.remainder(dividingBy: 10) == 0 {
            flyingWordsView?.layoutIfNeeded(move: 1)
//        }
        displayCount = displayCount + 1
    }
    
    @objc func test() {
        flyingWordsView?.setNeedsDisplay()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        flyingWordsView?.frame = view.bounds
    }
}
