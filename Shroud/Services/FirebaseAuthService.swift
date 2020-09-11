//
//  FirebaseAuthService.swift
//  Shroud
//
//  Created by Lynk on 9/8/20.
//  Copyright © 2020 Lynk. All rights reserved.
//

import Foundation
import FirebaseAuth

enum GenericError: Error {
    case unknown
    case usernameFound
    case friendFound
}

extension GenericError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .unknown:
            return NSLocalizedString("Unknown Error", comment: "Unknown Error")
        case .usernameFound:
            return NSLocalizedString("Username already taken!", comment: "username error")
        case .friendFound:
            return NSLocalizedString("Username not found!", comment: "username error")
        }
    }
}

class FirebaseAuthService {

    // MARK:- Static Properties

    static let manager = FirebaseAuthService()

    // MARK:- Internal Functions

    func loginUser(withEmail email: String, andPassword password: String, onCompletion: @escaping (Result<User, Error>) -> Void) {
        firebaseAuth.signIn(withEmail: email, password: password) { (result, error) in
            if let user = result?.user {
                onCompletion(.success(user))
            } else {
                onCompletion(.failure(error ?? GenericError.unknown))
            }
        }
    }

    func createNewUser(_ email: String, _ password: String, _ username: String, onCompletion: @escaping (Result<User, Error>) -> Void) {
        
        
        FirestoreService.manager.usernameValid(username) { (result) in
            switch result {
            case let .success(success):
                if success {
                    self.firebaseAuth.createUser(withEmail: email, password: password) { (result, error) in
                               if let createdUser = result?.user {
                                   onCompletion(.success(createdUser))
                               } else {
                                   onCompletion(.failure(error ?? GenericError.unknown))
                               }
                           }

                } else {
                    onCompletion(.failure(GenericError.usernameFound))
                }
                
            case let .failure(error):
                onCompletion(.failure(error))
            }
        }
        
        
        
        
        
       
        
        
        
        
    }


    var currentUser: User? {
        return firebaseAuth.currentUser
    }


    private let firebaseAuth = Auth.auth()


    private init() {}
}
