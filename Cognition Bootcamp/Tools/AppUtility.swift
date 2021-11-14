//
//  AppUtility.swift
//  Instinct
//
//  Created by Greg DeJong on 8/17/19.
//  Copyright © 2019 Sports Academy. All rights reserved.
//
//  Make sure that "Requires full screen" is checked in Target Settings -> General -> Deployment Info. supportedInterfaceOrientationsFor delegate will not get called if that is not checked.

import UIKit

struct AppUtility {
    static func lockOrientation(_ orientation: UIInterfaceOrientationMask) {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.orientationLock = orientation;
        } else {
            print("invalid delegate type")
        }
    }

    static func lockOrientation(_ orientation: UIInterfaceOrientationMask, andRotateTo rotateOrientation: UIInterfaceOrientation) {
        self.lockOrientation(orientation)

        UIDevice.current.setValue(rotateOrientation.rawValue, forKey: "orientation")
        UINavigationController.attemptRotationToDeviceOrientation()
    }
}
