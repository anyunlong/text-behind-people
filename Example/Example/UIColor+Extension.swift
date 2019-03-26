//
//  UIColor+Extension.swift
//  Example
//
//  Created by Yunlong An on 2019/3/26.
//  Copyright © 2019 Yunlong An. All rights reserved.
//

import UIKit

extension UIColor {
    static var random: UIColor {
        return UIColor(red: .random(in: 0...1),
                       green: .random(in: 0...1),
                       blue: .random(in: 0...1),
                       alpha: 1.0)
    }
}
