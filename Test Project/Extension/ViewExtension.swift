//
//  ViewExtension.swift
//  Test Project
//
//  Created by Acemero on 30/08/22.
//

import UIKit
import Foundation

extension UIView {
    func addBottomShadow() {
        layer.masksToBounds = false
        layer.shadowRadius = 16
        layer.shadowOpacity = 1
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 10 , height: 2)
        layer.shadowPath = UIBezierPath(rect: CGRect(x: 0, y: bounds.maxY - layer.shadowRadius, width: bounds.width,height: layer.shadowRadius)).cgPath
    }
}
