//
//  ShroudUser.swift
//  
//
//  Created by Lynk on 9/8/20.
//

import Foundation
import FirebaseAuth

struct ShroudUser {
    let email: String?
    let uid: String
    let username: String
    let status: String

    init(from user: User, username: String, status: String) {
        self.email = user.email
        self.uid = user.uid
        self.username = username
        self.status = status
    }
    
    init?(dictionary: [String: Any]) {
        guard let email = dictionary["email"] as? String,
              let uid = dictionary["uid"] as? String,
              let username = dictionary["username"] as? String,
              let status = dictionary["status"] as? String else { return nil }
        
        self.email = email
        self.uid = uid
        self.username = username
        self.status = status
    }
    
    
    
    var fieldsDict: [String: Any] {
        return [
            "email": email ?? "",
            "username": username,
            "uid": uid,
            "status": status
        ]
    }
}
