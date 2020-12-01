//
//  UserDefaults.swift
//  Shroud
//
//  Created by Lynk on 12/1/20.
//  Copyright © 2020 Lynk. All rights reserved.
//

import Foundation


class Default {
    static func hasSetUserPhoto() -> Bool {
        return UserDefaults.standard.bool(forKey: "userPhoto")
    }
    
    static func setFirstTimeUserPhoto() {
        UserDefaults.standard.setValue(true, forKey: "userPhoto")
    }
}
