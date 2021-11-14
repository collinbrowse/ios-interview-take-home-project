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
    let db = Firestore.firestore()
    let userScoresCollection = "scores"
    var uid: String?
    var listenerUserScores: ListenerRegistration?
    
    private init() {
        
        Auth.auth().signInAnonymously { authResult, error in
            guard let user = authResult?.user else { return }
            //let isAnonymous = user.isAnonymous  // true
            self.uid = user.uid
        }
    }
    
    
    func removeFirestoreListeners() {
        listenerUserScores?.remove()
    }
    
    
    func getCurrentLeaderboard(completed: @escaping ([UserScore]) -> Void) {
        
        listenerUserScores = db.collection(userScoresCollection).order(by: "totalTime", descending: false).limit(to: 10).addSnapshotListener { querySnapshot, error in
            if let error = error {
                print("Error getting the collection: \(error)")
                // The listener will no longer receive any more events.
            } else if let snapshot = querySnapshot {
                let source = snapshot.metadata.isFromCache ? "local cache" : "server"
                print("Metadata: Data fetched from \(source)")
                let leaderboard = snapshot.documents.compactMap({UserScore(dictionary: $0.data())})
                completed(leaderboard)
            }
        }
    }
    
    
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
