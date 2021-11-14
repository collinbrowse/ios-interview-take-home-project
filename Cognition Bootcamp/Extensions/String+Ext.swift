//
//  NSAttributedString+Ext.swift
//  Cognition Bootcamp
//
//  Created by Collin Browse on 11/13/21.
//

import UIKit

extension String {
    
    func formatTimeLabel(time: Double, isAltColorDark: Bool) -> NSAttributedString {
        
        var attributes = [NSAttributedString.Key: AnyObject]()
        attributes[.foregroundColor] = UIColor.gold
        let mutableAttributedString = NSMutableAttributedString.init(string: self, attributes: attributes)
        
        var range1 = NSRange(location: 0, length: 1)
        var rangeOfPeriod = NSRange(location: 1, length: 1)
        var range2 = NSRange(location: 2, length: 4)
        var rangeOfSecond = NSRange(location: 5, length: 1)
        if time >= 10 {
            range1 = NSRange(location: 0, length: 2)
            rangeOfPeriod = NSRange(location: 2, length: 1)
            range2 = NSRange(location: 3, length: 4)
            rangeOfSecond = NSRange(location: 6, length: 1)
        } else if time >= 100 {
            range1 = NSRange(location: 0, length: 3)
            rangeOfPeriod = NSRange(location: 3, length: 1)
            range2 = NSRange(location: 4, length: 4)
            rangeOfSecond = NSRange(location: 7, length: 1)
        }
        var altColor = UIColor()
        if isAltColorDark {
            altColor = UIColor.background1
        } else {
            altColor = UIColor(named: "Background1Flipped")  ?? UIColor.gold
        }
        mutableAttributedString.addAttribute(.foregroundColor, value: UIColor.gold, range: range1)
        mutableAttributedString.addAttribute(.foregroundColor, value: altColor , range: rangeOfPeriod)
        mutableAttributedString.addAttribute(.foregroundColor, value: UIColor.gold, range: range2)
        mutableAttributedString.addAttribute(.foregroundColor, value: altColor, range: rangeOfSecond)
        return(mutableAttributedString)
    }
}
