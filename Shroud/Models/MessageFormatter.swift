//
//  MessageFormatter.swift
//  Shroud
//
//  Created by Lynk on 9/25/20.
//  Copyright © 2020 Lynk. All rights reserved.
//

import Foundation
import FirebaseFirestore


class MessageFormatter {
    private var friendUID = ""
    private var fontColor: UIColor = .white
    private var fontType: FontType = .regular
    private var fontSize: FontSize = .regular
    
    func setColorText(color: UIColor) {
        fontColor = color
    }
    
    func setWhiteText() {
        fontColor = .white
    }
    
    func setBoldText() {
        fontType = .bold
    }
    
    func setLightText() {
        fontType = .light
    }
    
    func setRegText() {
        fontType = .regular
    }
    
    func setSmallText() {
        fontSize = .small
    }
    
    func setLargeText() {
        fontSize = .large
    }
    
    func setDefaultTextSize() {
        fontSize = .regular
    }
    
    func updateInput(_ input: UITextView) {
        switch (fontType,fontSize) {
        case (.bold,.regular):
            input.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        case (.light,.regular):
            input.font = UIFont.systemFont(ofSize: 15, weight: .ultraLight)
        case (.regular,.regular):
            input.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        case (.bold,.large):
            input.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        case (.light,.large):
            input.font = UIFont.systemFont(ofSize: 17, weight: .ultraLight)
        case (.regular,.large):
            input.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        case (.bold,.small):
            input.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        case (.light,.small):
            input.font = UIFont.systemFont(ofSize: 13, weight: .ultraLight)
        case (.regular,.small):
            input.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        }
        
        input.textColor = fontColor
    }
    
    func setFriend(_ friendUID: String) {
        self.friendUID = friendUID
    }
    
    func createMessage(_ messageText: String) -> Message? {
        guard let user = FirebaseAuthService.manager.currentUser else { return nil }
        return Message(messageText, user.uid, fontSize, fontColor, fontType, users: [user.uid,friendUID], read: false, timestamp: Timestamp(date: Date()))
    }
    
}
