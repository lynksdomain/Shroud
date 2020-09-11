//
//  FirestoreService.swift
//  
//
//  Created by Lynk on 9/8/20.
//

import FirebaseFirestore

class FirestoreService {


    static let manager = FirestoreService()
    private let db = Firestore.firestore()
    
    func usernameValid(_ username: String, onCompletion: @escaping (Result<Bool, Error>) -> Void) {
        db.collection("users").whereField("username", isEqualTo: username).getDocuments { (snapshot, error) in
            if let error = error {
                onCompletion(.failure(error))
            } else {
                if snapshot!.documents.count > 0 {
                    onCompletion(.success(false))
                } else {
                    onCompletion(.success(true))
                }
            }
        }
    }
    
    func create(_ user: ShroudUser, onCompletion: @escaping (Result<Void, Error>) -> Void) {
        db.collection("users").document(user.uid).setData(user.fieldsDict) { error in
            if let error = error {
                onCompletion(.failure(error))
            } else {
                onCompletion(.success(()))
            }
        }
    }
    
    
    func addFriend(_ username: String, onCompletion: @escaping (Result<Void, Error>) -> Void) {
        db.collection("users").whereField("username", isEqualTo: username).getDocuments { (snapshot, error) in
            if let error = error {
                onCompletion(.failure(error))
            } else {
                if let snapshot = snapshot,
                    snapshot.documents.count > 0,
                    let shroudUser = ShroudUser(dictionary: snapshot.documents[0].data()) {
                    self.db.collection("users").document(FirebaseAuthService.manager.currentUser!.uid).collection("friends").document(shroudUser.uid).setData(shroudUser.fieldsDict) { error in
                        if let error = error {
                            onCompletion(.failure(error))
                        } else {
                            onCompletion(.success(()))
                        }
                    }
                } else {
                    onCompletion(.failure(GenericError.friendFound))
                }
            }
        }
    }
}
