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
    
    
    func sendImage(picture:Data, onCompletion: @escaping (Result<URL,Error>) -> Void ) {
        let folderRef = storage.reference().child("MessageImages")
        let pictureRef = folderRef.child("\(UUID().uuidString).jpg")
        
        pictureRef.putData(picture, metadata: nil) { (meta, error) in
            if let _ = meta {
                pictureRef.downloadURL { (url, error) in
                    if let url = url {
                        onCompletion(.success(url))
                    } else if let error = error {
                        onCompletion(.failure(error))
                    }
                }
            } else if let error = error {
                onCompletion(.failure(error))
            }
        }
    }
    
    func addProfileImage(user: ShroudUser, profilePicture: Data, onCompletion: @escaping (Result<URL,Error>) -> Void ) {
        let folderRef = storage.reference().child("UserPicture")
        let pictureRef = folderRef.child("\(user.uid).jpg")
        
        pictureRef.putData(profilePicture, metadata: nil) { (meta, error) in
            if let _ = meta {
                pictureRef.downloadURL { (url, error) in
                    if let url = url {
                        FirestoreService.manager.updateProfilePicture(uid: user.uid, url: url.absoluteString) { (result) in
                            switch result {
                            case .success(()):
                                onCompletion(.success((url)))
                            case let .failure(error):
                                onCompletion(.failure(error))
                            }
                        }
                    } else if let error = error {
                        onCompletion(.failure(error))
                    }
                }
            } else if let error = error {
                onCompletion(.failure(error))
            }
        }
    }
    
}
