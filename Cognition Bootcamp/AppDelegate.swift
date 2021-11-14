//
//  AppDelegate.swift
//  Cognition Bootcamp
//
//  Created by Greg DeJong on 10/8/20.
//

import UIKit
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var orientationLock:UIInterfaceOrientationMask = .allButUpsideDown
    var window: UIWindow?
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return self.orientationLock
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        FirebaseApp.configure()
        let _ = Firestore.firestore()
        return true 
    }
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        NetworkManager.shared.removeFirestoreListeners()
        print("Resign Active")
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        
    }
}

