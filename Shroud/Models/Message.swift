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



enum FontType: String {
    case regular, bold, light
}

struct Message {
    let message: String
    let authorUID: String
    let fontSize: FontSize
    let fontColor: UIColor
    let fontType: FontType
    let users: [String]
    let read: Bool
    let timestamp: Timestamp
    
    init(_ message: String, _ authorUID: String, _ fontSize: FontSize, _ fontColor: UIColor, _ fontType: FontType, users: [String], read: Bool, timestamp: Timestamp) {
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
              let red = dictionary["red"] as? CGFloat,
              let blue = dictionary["blue"] as? CGFloat,
              let green = dictionary["green"] as? CGFloat,
              let fontTypeString = dictionary["fontType"] as? String,
              let fontSize = FontSize(rawValue: fontSizeString),
              let fontType = FontType(rawValue: fontTypeString),
              let users = dictionary["users"] as? [String],
              let read = dictionary["read"] as? Bool,
              let timestamp = dictionary["timestamp"] as? Timestamp else { return nil }
        
        self.message = message
        self.authorUID = authorUID
        self.fontSize = fontSize
        self.fontColor = UIColor.init(red: red, green: green, blue: blue, alpha: 1.0)
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
            "red":fontColor.rgbComponents.red,
            "blue":fontColor.rgbComponents.blue,
            "green":fontColor.rgbComponents.green,
            "fontType":fontType.rawValue,
            "users":users,
            "read":read,
            "timestamp":timestamp
        ]
    }
    
}
