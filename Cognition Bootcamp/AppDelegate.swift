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
    
    var orientationLock: UIInterfaceOrientationMask = .portraitUpsideDown
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        FirebaseApp.configure()
        let _ = Firestore.firestore()
        let _ = NetworkManager.shared // Authenticate the user. Needed for very first load
        return true 
    }
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        NetworkManager.shared.removeFirestoreListeners()
    }
    
    
    
    func applicationWillTerminate(_ application: UIApplication) {
        NetworkManager.shared.logoutFirebase()
    }
}

