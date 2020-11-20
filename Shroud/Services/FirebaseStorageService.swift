//
//  FirebaseStorageService.swift
//  Shroud
//
//  Created by Lynk on 11/19/20.
//  Copyright © 2020 Lynk. All rights reserved.
//

import Foundation
import FirebaseStorage


class FirebaseStorageService {

    private init(){}
    static let manager = FirebaseStorageService()
    
    let storage = Storage.storage()

    func addProfileImage(user: ShroudUser, profilePicture: Data, onCompletion: @escaping (Result<Void,Error>) -> Void ) {
        let folderRef = storage.reference().child("UserPicture")
        let pictureRef = folderRef.child("\(user.uid).jpg")
        
        pictureRef.putData(profilePicture, metadata: nil) { (meta, error) in
            if let _ = meta {
                onCompletion(.success(()))
            } else if let error = error {
                onCompletion(.failure(error))
            }
        }
    }
    
}
