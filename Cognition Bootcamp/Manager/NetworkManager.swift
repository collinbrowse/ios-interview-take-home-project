//
//  NetworkManager.swift
//  Cognition Bootcamp
//
//  Created by Collin Browse on 11/10/21.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class NetworkManager {
    
    static let shared = NetworkManager()
    
    var uid: String?
    private let db = Firestore.firestore()
    private let userScoresCollection = "scores"
    private var listenerUserScores: ListenerRegistration?
    
    
    /// Create a shared instance of the Network Manager to perform requests
    /// This initialized performs an anonymous authentication to Firebase Auth to authenticate network requests
    private init() {
        Auth.auth().signInAnonymously { [weak self] authResult, error in
            guard let self = self else { return }
            guard let user = authResult?.user else { return }
            self.uid = user.uid
        }
    }
    
    
    /// This function removes Firebase Firestore listeners so that the app does not continue to respond to new DB entries.
    /// Desired functionality is to call this app from applicationWillResignActive
    func removeFirestoreListeners() {
        listenerUserScores?.remove()
    }
    
    
    /// Log the user out from Firebase
    func logoutFirebase() {
        do {
            try Auth.auth().signOut()
        } catch {
            print("Unable to sign out")
        }
    }
    
    
    /// Fetches the leaderboard from Firebase Firestore
    ///
    /// - returns:an array of UserScore Objects
    func getCurrentLeaderboard(completed: @escaping ([UserScore]) -> Void) {
        
        
        listenerUserScores = db.collection(userScoresCollection)
            .order(by: "totalTime", descending: false)
            .limit(to: 10)
            .addSnapshotListener { querySnapshot, error in
            if let error = error {
                print("Error getting the collection: \(error)")
                // The listener will no longer receive any more events.
            } else if let snapshot = querySnapshot {
                let leaderboard = snapshot.documents.compactMap({UserScore(dictionary: $0.data())})
                completed(leaderboard)
            }
        }
    }
    
    
    /// Adds a new score to the Firebase Firestore DB
    ///
    /// - parameters: A [String: Any] dictionary that should contain the 4 keys for a user score: initials, createdAt, totalTime, reactionTime
    func addNewScore(_ newScore: [String: Any], completed: @escaping(Bool) -> Void) {
        
        db.collection(userScoresCollection).addDocument(data: newScore) { err in
            if let err = err {
                print("Error adding document: \(err)")
                completed(false)
            } else {
                print("Successfully added new score")
                completed(true)
            }
        }
    }
}
