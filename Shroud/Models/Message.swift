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

enum MessageType: String {
    case text, image
}

enum FontType: String {
    case regular, bold, light
}

struct Message {
    let messageType: MessageType
    var message: String?
    let authorUID: String
    var fontSize: FontSize?
    var fontColor: UIColor?
    var fontType: FontType?
    let users: [String]
    let read: Bool
    let timestamp: Timestamp
    var imageURL: String?
    
    init(_ message: String, _ authorUID: String, _ fontSize: FontSize, _ fontColor: UIColor, _ fontType: FontType, users: [String], read: Bool, timestamp: Timestamp) {
        self.messageType = .text
        self.message = message
        self.authorUID = authorUID
        self.fontSize = fontSize
        self.fontColor = fontColor
        self.fontType = fontType
        self.users = users
        self.read = read
        self.timestamp = timestamp
    }
    
    init(_ imageURL: String, _ authorUID: String, users: [String], read: Bool, timestamp: Timestamp) {
        self.messageType = .image
        self.authorUID = authorUID
        self.users = users
        self.read = read
        self.timestamp = timestamp
        self.imageURL = imageURL
    }
    
    
    
    
    
    init?(dictionary: [String:Any]) {
        guard let messageTypeString = dictionary["messageType"] as? String,
              let authorUID = dictionary["uid"] as? String,
              let users = dictionary["users"] as? [String],
              let read = dictionary["read"] as? Bool,
              let timestamp = dictionary["timestamp"] as? Timestamp,
              let messageType = MessageType(rawValue: messageTypeString) else { return nil }
        
        
        self.authorUID = authorUID
        self.users = users
        self.read = read
        self.timestamp = timestamp
        self.messageType = messageType
        

        if messageType == .text {
        guard let message = dictionary["message"] as? String,
              let fontSizeString =  dictionary["fontSize"] as? String,
              let red = dictionary["red"] as? CGFloat,
              let blue = dictionary["blue"] as? CGFloat,
              let green = dictionary["green"] as? CGFloat,
              let fontTypeString = dictionary["fontType"] as? String,
              let fontSize = FontSize(rawValue: fontSizeString),
              let fontType = FontType(rawValue: fontTypeString) else { return nil }
        
        self.message = message
        self.fontSize = fontSize
        self.fontColor = UIColor.init(red: red, green: green, blue: blue, alpha: 1.0)
        self.fontType = fontType
        } else {
            guard let imageURL = dictionary["imageURL"] as? String else { return nil }
            self.imageURL = imageURL
        }
    }
    
    
    var fieldsDict: [String:Any] {
        if messageType == .text {
            
            guard let fontSize = fontSize,
                  let fontColor = fontColor,
                  let fontType = fontType,
                  let message = message else { return [:] }
            
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
                "timestamp":timestamp,
                "messageType":messageType.rawValue
            ]
        } else {
            guard let imageURL = imageURL else { return [:] }
            return [
                "imageURL":imageURL,
                "uid":authorUID,
                "users":users,
                "read":read,
                "timestamp":timestamp,
                "messageType":messageType.rawValue
            ]
        }
    }
    
}
