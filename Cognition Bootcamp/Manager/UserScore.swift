//
//  UserScore.swift
//  Cognition Bootcamp
//
//  Created by Collin Browse on 11/10/21.
//

import Foundation
import FirebaseFirestore


/// Provide an optional initializer for a user score that can accept a dictionary
protocol UserScoreSerializable {
    init?(dictionary: [String: Any])
}

struct UserScore: Codable {
    
    var initials: String
    var totalTime: Double
    var createdAt: Date
    var reactionTime: Double
    
    var dictionary: [String: Any] {
        return [
            "initials": initials,
            "totalTime": totalTime,
            "createdAt": createdAt,
            "reactionTime": reactionTime
        ]
    }
}


extension UserScore: UserScoreSerializable {
    
    init?(dictionary: [String : Any]) {
        
        guard let initials = dictionary["initials"] as? String,
            let totalTime = dictionary["totalTime"] as? Double,
            let timestamp = dictionary["createdAt"] as? Timestamp,
            let reactionTime = dictionary["reactionTime"] as? Double
        else { return nil }
        
        self.init(initials: initials, totalTime: totalTime, createdAt: timestamp.dateValue(), reactionTime: reactionTime)
    }
}
