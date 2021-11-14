//
//  UIButton+Ext.swift
//  Cognition Bootcamp
//
//  Created by Collin Browse on 11/10/21.
//

import UIKit

extension UIButton {
    
    func addGoldGradientBackground() {
        clipsToBounds = true
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = bounds
        gradient.colors = [
            UIColor(red: 0.9, green: 0.808, blue: 0.596, alpha: 1).cgColor,
            UIColor(red: 0.765, green: 0.655, blue: 0.404, alpha: 1).cgColor
          ]
        gradient.locations = [0,1]
        gradient.startPoint = CGPoint(x: 0.5, y: 0.25)
        gradient.endPoint = CGPoint(x: 0.5, y: 0.75)
        layer.insertSublayer(gradient, at: 0)
    }
    
    
    func addVLCornerRadius() {
        layer.cornerRadius = 8
    }
}
