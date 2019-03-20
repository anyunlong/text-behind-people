//
//  MaskView.swift
//  VisionFaceTrack
//
//  Created by Yunlong An on 2019/3/17.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class MaskView: UIView {
    
    var path: CGPath?

    override func draw(_ rect: CGRect) {
        UIColor.green.withAlphaComponent(0.5).setFill()
        UIRectFill(rect)
        
        guard let newPath = path else {
            return
        }
//        UIBezierPath(cgPath: newPath).fill(with: .clear, alpha: 1)
    }
}
