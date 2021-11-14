//
//  Double+Ext.swift
//  Cognition Bootcamp
//
//  Created by Collin Browse on 11/12/21.
//

import Foundation


extension Double {
    
    func roundedUp() -> Double {
        return (self * 1000).rounded(.up) / 1000
    }
}
