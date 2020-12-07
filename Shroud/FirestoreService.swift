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
    
    
    func getCurrentShroudUser(_ completion: @escaping (Result<ShroudUser, Error>) -> Void) {
        guard let currentUser = FirebaseAuthService.manager.currentUser else { return }
        db.collection("users").document(currentUser.uid).addSnapshotListener { (snapshot, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                guard let data = snapshot?.data(),
                      let user = ShroudUser(dictionary: data) else { return }
                completion(.success(user))
            }
        }
    }
    
    
    
    
    
    func updateProfilePicture(uid: String, url:String, onCompletion: @escaping (Result<Void, Error>) -> Void) {
        db.collection("users").document(uid).updateData(["profilePicture":url]) { (error) in
            if let error = error {
                onCompletion(.failure(error))
            } else {
                onCompletion(.success(()))
            }
        }
    }
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
    
    
    func blockFriend(_ uid: String, _ friend: ShroudUser) {
        //add friend user to block collection
        db.collection("users").document(uid).collection("blocked").document(friend.uid).setData(friend.fieldsDict) { (error) in
            self.deleteFriend(uid, friend.uid)
        }
    }
    
    
    
    
    func deleteFriend(_ uid: String, _ friendUid: String) {
        let batch = db.batch()
        //delete user from your collection
        let userRef = db.collection("users").document(uid).collection("friends").document(friendUid)
        //delete yourself from their collection
        let friendRef = db.collection("users").document(friendUid).collection("friends").document(uid)
        batch.deleteDocument(userRef)
        batch.deleteDocument(friendRef)
        batch.commit()
        
        var batches = [WriteBatch]()
        //delete conversations
        db.collection("users").document(uid).collection("messages").whereField("users", arrayContains: friendUid).getDocuments { (snapshot, error) in
            var overallCount = 0
            if let snapshot = snapshot {
                var count = 0
                for document in snapshot.documents {
                    if batches.isEmpty { batches.append(self.db.batch()) }
                    if count == 500 {
                        batches.append(self.db.batch())
                        batches[batches.count - 1].deleteDocument(document.reference)
                        count = 1
                    } else {
                        batches[batches.count - 1].deleteDocument(document.reference)
                        count += 1
                    }
                }
                overallCount = count
            }
            
            self.db.collection("users").document(friendUid).collection("messages").whereField("users", arrayContains: uid).getDocuments { (snapshot, error) in
                if let snapshot = snapshot {
                    var count = overallCount
                    for document in snapshot.documents {
                        if batches.isEmpty { batches.append(self.db.batch()) }
                        if count == 500 {
                            batches.append(self.db.batch())
                            batches[batches.count - 1].deleteDocument(document.reference)
                            count = 1
                        } else {
                            batches[batches.count - 1].deleteDocument(document.reference)
                            count += 1
                        }
                    }
                }
                batches.forEach{ $0.commit() }
            }
        }
    }
    
    
    
    func addIsValid(_ username:String, _ uid: String ,onCompletion: @escaping (Result<ShroudUser, Error>) -> Void) {
        
        db.collection("users").whereField("username", isEqualTo: username).getDocuments { (snapshot, error) in
            
            if let error = error {
                onCompletion(.failure(error))
            } else {
                if let snapshot = snapshot,
                   snapshot.documents.count > 0,
                   let shroudUser = ShroudUser(dictionary: snapshot.documents[0].data()) {
                    
                    self.db.collection("users").document(uid).collection("blocked").document(shroudUser.uid).getDocument { (doc, error) in
                        if let doc = doc,
                           doc.exists {
                            onCompletion(.failure(GenericError.friendFound))
                        } else {
                            
                            self.db.collection("users").document(shroudUser.uid).collection("blocked").document(uid).getDocument { (doc, error) in
                                if let doc = doc,
                                   doc.exists {
                                    onCompletion(.failure(GenericError.friendFound))
                                } else {
                                    onCompletion(.success(shroudUser))
                                }
                            }
                            
                        }
                    }
                } else {
                    onCompletion(.failure(GenericError.friendFound))
                }
            }
        }
    }
    
    
    func addFriend(_ username: String, onCompletion: @escaping (Result<Void, Error>) -> Void) {
        guard let current = FirebaseAuthService.manager.currentUser else { return }
        
        
        addIsValid(username, current.uid) { (result) in
            switch result {
            case let .success(friend):
                self.db.collection("users").document(current.uid).collection("friends").document(friend.uid).setData(friend.fieldsDict) {
                    error in
                    
                    if let error = error {
                        onCompletion(.failure(error))
                    } else {
                        
                        
                        self.getCurrentShroudUser { (result) in
                            
                            switch result {
                            case let .failure(error):
                                onCompletion(.failure(error))
                            case let .success(user):
                                self.db.collection("users").document(friend.uid).collection("friends").document(user.uid).setData(user.fieldsDict){ error in
                                    if let error = error {
                                        onCompletion(.failure(error))
                                    } else {
                                        onCompletion(.success(()))
                                    }
                                }
                            }
                        }
                    }
                }
            case let .failure(error):
                onCompletion(.failure(error))
            }
        }
    }

    
    
    func fetchFriends(onCompletion: @escaping (Result<[ShroudUser],Error>) -> Void) {
        guard let current = FirebaseAuthService.manager.currentUser else {
            onCompletion(.failure(GenericError.unknown))
            return
        }
        
        db.collection("users").document(current.uid).collection("friends").addSnapshotListener({ (snapshot, error) in
            if let error = error {
                onCompletion(.failure(error))
            } else {
                if let snapshot = snapshot {
                    var ids = [String]()
                    for document in snapshot.documents {
                        guard let id = document.data()["uid"] as? String else { continue }
                        ids.append(id)
                    }
                    
                    self.db.collection("users").whereField("uid", in: ids).addSnapshotListener { (snapshot, error) in
                        if let error = error {
                            onCompletion(.failure(error))
                        } else {
                            if let snapshot = snapshot {
                                var friends = [ShroudUser]()
                                for document in snapshot.documents {
                                    guard let user = ShroudUser.init(dictionary: document.data()) else { return }
                                    friends.append(user)
                                }
                                onCompletion(.success(friends))
                            }
                        }
                    }
                }
            }
        })
}
    
    func fetchUnreadMessages(onCompletion: @escaping ((Result<[Message], Error>) -> Void)) {
        guard let current = FirebaseAuthService.manager.currentUser else {
            onCompletion(.failure(GenericError.unknown))
            return
        }
        db.collection("users").document("\(current.uid)").collection("messages").whereField("users", arrayContains: current.uid).whereField("read", isEqualTo: false).whereField("uid", isNotEqualTo: current.uid).addSnapshotListener { (snapshot, error) in
            if let error = error {
                onCompletion(.failure(error))
            } else {
                if let snapshot = snapshot {
                   
                    
                  var messages = [Message]()
                    for document in snapshot.documents {
                        guard let message = Message(dictionary: document.data()) else { continue }
                        
                        
                        
                        messages.append(message)
                    
                    }
                    print(messages)
                    onCompletion(.success(messages))
                }
            }
        }
    }
    
    func fetchConversation(friendUID: String, _ onCompletion: @escaping (Result<[Message],Error>) -> Void) {
        guard let current = FirebaseAuthService.manager.currentUser else {
            onCompletion(.failure(GenericError.unknown))
            return
        }
        db.collection("users").document("\(current.uid)").collection("messages").whereField("users", in: [["\(friendUID)","\(current.uid)"],["\(current.uid)","\(friendUID)"]]).order(by: "timestamp", descending: false).addSnapshotListener { (snapshot, error) in
            if let error = error {
                onCompletion(.failure(error))
            } else {
                if let snapshot = snapshot {
                   
                    
                  var messages = [Message]()
                    for document in snapshot.documents {
                        guard let message = Message(dictionary: document.data()) else { continue }
                        
                        
                        
                        messages.append(message)
                    }
                    
                    print(messages)
                    onCompletion(.success(messages))
                }
        }
    }

    }
    
    func fetchStatus(friendUID: String, _ onCompletion: @escaping (Result<String,Error>) -> Void) {
        db.collection("users").document(friendUID).addSnapshotListener { (snapshot, error) in
            if let snapshot = snapshot {
                guard let data = snapshot.data(),
                      let user = ShroudUser(dictionary: data) else { onCompletion(.failure(GenericError.unknown))
                    return
                }
                onCompletion(.success(user.status))
            } else if let error = error {
                onCompletion(.failure(error))
            }
        }
    }
    
    
    
    func updateUnreadMessage(friendUID: String, _ onCompletion: @escaping (Result<Void,Error>) -> Void) {
        let batch = db.batch()
        guard let current = FirebaseAuthService.manager.currentUser else {
            onCompletion(.failure(GenericError.unknown))
            return
        }
        db.collection("users").document("\(current.uid)").collection("messages").whereField("read", isEqualTo: false).whereField("uid", isEqualTo: friendUID).getDocuments { (snapshot, error) in
            guard let snapshot = snapshot else { return }
            snapshot.documents.forEach { (document) in
                batch.updateData(["read":true], forDocument: document.reference)
            }
            batch.commit { (error) in
                if let error = error {
                    onCompletion(.failure(error))
                } else {
                    onCompletion(.success(()))
                }
            }
        }
    }
    
    func sendMessage(_ friendUID: String, _ message: Message, _ onCompletion: @escaping (Result<Void,Error>) -> Void) {
        let batch = db.batch()
        guard let current = FirebaseAuthService.manager.currentUser else {
            onCompletion(.failure(GenericError.unknown))
            return
        }
        let currentRef = db.collection("users").document("\(current.uid)").collection("messages").document()
        let friendRef = db.collection("users").document("\(friendUID)").collection("messages").document()
        batch.setData(message.fieldsDict, forDocument: currentRef)
        batch.setData(message.fieldsDict, forDocument: friendRef)
        
        batch.commit { (error) in
            if let error = error {
                onCompletion(.failure(error))
            } else {
                onCompletion(.success(()))
            }
        }
        
    }
    
    
    
    func updateStatus(_ newStatus: String, _ onCompletion: @escaping (Result<Void,Error>) -> Void) {
      
        guard let user = FirebaseAuthService.manager.currentUser else {
            onCompletion(.failure(GenericError.unknown))
            return
        }
        
        db.collection("users").document("\(user.uid)").updateData(["status":newStatus]) { (error) in
            if let error = error {
                onCompletion(.failure(error))
            } else {
                
                
                
                
                
                
                onCompletion(.success(()))
            }
        }
        
    }
    
    func fetchBlockedUsers(_ onCompletion: @escaping (Result<[ShroudUser],Error>) -> Void) {
        guard let current = FirebaseAuthService.manager.currentUser else { return }
        db.collection("users").document(current.uid).collection("blocked").addSnapshotListener { (snapshot, error) in
            if let snapshot = snapshot {
                
                var users = [ShroudUser]()
                
                for document in snapshot.documents {
                    guard let user = ShroudUser(dictionary: document.data()) else { continue }
                    users.append(user)
                }
                
                onCompletion(.success(users))
                
            } else if let error = error {
                onCompletion(.failure(error))
            }
        }
        
        
    }
    
    
    func unblockUser(friendUID:String, onCompletion: @escaping (Result<Void,Error>) -> Void ) {
        guard let currentUser = FirebaseAuthService.manager.currentUser else { return }
        
        db.collection("users").document(currentUser.uid).collection("blocked").document(friendUID).delete { (error) in
            if let error = error {
                onCompletion(.failure(error))
            } else {
                onCompletion(.success(()))
            }
        }
        
    }
    
    
}


