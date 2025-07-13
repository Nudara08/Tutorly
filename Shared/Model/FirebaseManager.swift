//
//  FirebaseManager.swift
//  Tutorly
//
//  Created by Nudara Jayasinghe on 26/6/2025.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseStorage

class FirebaseManager: NSObject {
    
    let auth: Auth
    let storage: Storage
    let firestore: Firestore
    
    static let shared = FirebaseManager()
    
    override init() {
        
        self.auth = Auth.auth()
        self.storage = Storage.storage()
        self.firestore = Firestore.firestore()
        
        super.init()
    }
    
}
    

