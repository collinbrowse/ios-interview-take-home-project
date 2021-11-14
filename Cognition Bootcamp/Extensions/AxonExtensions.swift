//
//  AxonExtensions.swift
//  Instinct
//
//  Created by Greg DeJong on 3/10/17.
//  Copyright © 2017 AxonSports. All rights reserved.
//

import UIKit

extension UILabel {
    
    /// adding space between each characters - defaults to kern of 2.4
    func addCharacterSpacing(kernValue: Double = 2.4) {
        if let labelText = text, labelText.isEmpty == false {
            let attributedString = NSMutableAttributedString(string: labelText)
            attributedString.addAttribute(.kern,
                                          value: kernValue,
                                          range: NSRange(location: 0, length: attributedString.length - 1))
            attributedText = attributedString
        }
    }
}

extension UIColor {
    
    static var gold:UIColor = UIColor(named: "Gold") ?? UIColor(red: 0.675, green: 0.612, blue: 0.388, alpha: 1)
    static var silver:UIColor = UIColor(named: "Silver") ?? UIColor(red: 0.725, green: 0.725, blue: 0.725, alpha: 1)
    static var bronze:UIColor = UIColor(named: "Bronze") ?? UIColor(red: 0.659, green: 0.498, blue: 0.4, alpha: 1)
    static var saRed:UIColor = UIColor(named: "SARed") ?? UIColor(red: 1, green: 0, blue: 0, alpha: 1)
    static var saGreen:UIColor = UIColor(named: "SAGreen") ?? UIColor(red: 0, green: 1, blue: 0, alpha: 1)
    static var background1:UIColor = UIColor(named: "Background1") ?? UIColor(red: 30/255, green: 30/255, blue: 30/255, alpha: 1)
    static var background2:UIColor = UIColor(named: "Background2") ?? UIColor(red: 20/255, green: 20/255, blue: 20/255, alpha: 1)
    static var background3:UIColor = UIColor(named: "Background3") ?? UIColor(red: 10/255, green: 10/255, blue: 10/255, alpha: 1)
    static var background4:UIColor = UIColor(named: "Background4") ?? UIColor(red: 0, green: 0, blue: 0, alpha: 1)
    
    func transparenter(by percentage: CGFloat = 15.0) -> UIColor? {
        return self.transparentAdjust(by: -1 * abs(percentage) )
    }
    func opaquer(by percentage: CGFloat = 15.0) -> UIColor? {
        return self.transparentAdjust(by: abs(percentage) )
    }
    
    private func transparentAdjust(by percentage: CGFloat = 15.0) -> UIColor? {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        if self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            return UIColor(red: red,
                           green: green,
                           blue: blue,
                           alpha: min(1.0, max(0, alpha + percentage/100)))
        } else {
            return nil
        }
    }
    
    func lighter(by percentage: CGFloat = 15.0) -> UIColor? {
        return self.adjust(by: abs(percentage) )
    }
    func darker(by percentage: CGFloat = 15.0) -> UIColor? {
        return self.adjust(by: -1 * abs(percentage) )
    }
    
    private func adjust(by percentage: CGFloat = 15.0) -> UIColor? {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        if self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            return UIColor(red: max(0, min(red + percentage/100, 1.0)),
                           green: max(0, min(green + percentage/100, 1.0)),
                           blue: max(0, min(blue + percentage/100, 1.0)),
                           alpha: alpha)
        } else {
            return nil
        }
    }
}

extension UIView {
    func rotateContinuously(for duration: Double = 2, reversed: Bool = false) {
        if (self.layer.animation(forKey: "rotationAnimation") == nil) {
            let rotation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
            rotation.toValue = reversed ? NSNumber(value: -Double.pi / 2) : NSNumber(value: Double.pi / 2)
            rotation.duration = duration
            rotation.isCumulative = true
            rotation.repeatCount = Float.greatestFiniteMagnitude
            self.layer.add(rotation, forKey: "rotationAnimation")
        }
    }
    
    func shake(count : Float? = nil,for duration : TimeInterval? = nil,
               withTranslation translation : CGFloat? = nil) {
        let animation : CABasicAnimation = CABasicAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.repeatCount = count ?? 3
        animation.duration = (duration ?? 0.1)/TimeInterval(animation.repeatCount)
        animation.autoreverses = true
        let trans = translation ?? 5;
        animation.fromValue = trans
        animation.toValue = -trans
        layer.add(animation, forKey: "shake")
    }
}
