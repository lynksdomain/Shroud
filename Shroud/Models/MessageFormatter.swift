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
    private var fontColor: FontColor = .white
    private var fontType: FontType = .regular
    private var fontSize: FontSize = .regular
    
    func setRedText() {
        fontColor = .red
    }
    
    func setWhiteText() {
        fontColor = .red
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
    
    func createMessage(_ messageText: String, _ friendUID: String) -> Message? {
        guard let user = FirebaseAuthService.manager.currentUser else { return nil }
        return Message(messageText, user.uid, fontSize, fontColor, fontType, users: [user.uid, friendUID ], read: false, timestamp: Timestamp(date: Date()))
    }
    
}
