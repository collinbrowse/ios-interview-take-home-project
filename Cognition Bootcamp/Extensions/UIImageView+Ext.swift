//
//  UIImageView+Ext.swift
//  Cognition Bootcamp
//
//  Created by Collin Browse on 11/10/21.
//

import UIKit


extension UIImageView {

    func setImageColor(color: UIColor) {
        let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
        self.image = templateImage
        self.tintColor = color
    }

}
