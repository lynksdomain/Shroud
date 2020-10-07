//
//  Message.swift
//  Shroud
//
//  Created by Lynk on 9/22/20.
//  Copyright © 2020 Lynk. All rights reserved.
//

import Foundation
import FirebaseFirestore

enum FontSize: String {
    case regular, large, small
}

enum FontColor: String {
    case white, red
}

enum FontType: String {
    case regular, bold, light
}

struct Message {
    let message: String
    let authorUID: String
    let fontSize: FontSize
    let fontColor: FontColor
    let fontType: FontType
    let users: [String]
    let read: Bool
    let timestamp: Timestamp
    
    init(_ message: String, _ authorUID: String, _ fontSize: FontSize, _ fontColor: FontColor, _ fontType: FontType, users: [String], read: Bool, timestamp: Timestamp) {
        self.message = message
        self.authorUID = authorUID
        self.fontSize = fontSize
        self.fontColor = fontColor
        self.fontType = fontType
        self.users = users
        self.read = read
        self.timestamp = timestamp
    }
    
    init?(dictionary: [String:Any]) {
        guard let message = dictionary["message"] as? String,
              let authorUID = dictionary["uid"] as? String,
              let fontSizeString =  dictionary["fontSize"] as? String,
              let fontColorString = dictionary["fontColor"] as? String,
              let fontTypeString = dictionary["fontType"] as? String,
              let fontSize = FontSize(rawValue: fontSizeString),
              let fontColor = FontColor(rawValue: fontColorString),
              let fontType = FontType(rawValue: fontTypeString),
              let users = dictionary["users"] as? [String],
              let read = dictionary["read"] as? Bool,
              let timestamp = dictionary["timestamp"] as? Timestamp else { return nil }
        
        self.message = message
        self.authorUID = authorUID
        self.fontSize = fontSize
        self.fontColor = fontColor
        self.fontType = fontType
        self.users = users
        self.read = read
        self.timestamp = timestamp
    }
    
    
    var fieldsDict: [String:Any] {
        return [
            "message":message,
            "uid":authorUID,
            "fontSize":fontSize.rawValue,
            "fontColor":fontColor.rawValue,
            "fontType":fontType.rawValue,
            "users":users,
            "read":read,
            "timestamp":timestamp
        ]
    }
    
}
