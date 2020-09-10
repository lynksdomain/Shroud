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

    init(from user: User, username: String) {
        self.email = user.email
        self.uid = user.uid
        self.username = username
    }

    var fieldsDict: [String: Any] {
        return [
            "email": email ?? "",
            "username": username,
            "uid": uid
        ]
    }
}



struct ShroudColors {
   static let darkGray = UIColor(displayP3Red: 25/255, green: 25/255, blue: 25/255, alpha: 1)
}
