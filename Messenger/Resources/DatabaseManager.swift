//
//  DatabaseManager.swift
//  Messenger
//
//  Created by Mohammed Saidam on 30/01/2023.
//

import Foundation
import FirebaseDatabase


final class DatabaseManager{
    // this class sengelton used because easy read and write operations
    
    static let shared = DatabaseManager()
    private let database = Database.database().reference()
    
}
//MARK: - Account Managment
extension DatabaseManager{
    
    public func userExist(email:String,completion:@escaping((Bool)-> Void )){
        
        var safeEmail = email.replacingOccurrences(of: ".", with: "_")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "_")
        
        database.child(safeEmail).observeSingleEvent(of:.value, with:{ snapshot  in
            guard snapshot.value as? String != nil else{
                completion(false)
                return
            }
            completion(true)
            
            
            
        })
        
        
    }
    
    /// Insert New User In Database
    public func insertUser(with user:ChatAppUser){
        database.child(user.safeEmail).setValue([
            "FirstName":user.firstName,
            "LastName":user.lastName
            
        ])
        
    }
}
    struct ChatAppUser{
        let firstName:String
        let lastName:String
        let email:String
        //let profilePictureURL:String
        var safeEmail:String {
            var safeEmail = email.replacingOccurrences(of: ".", with: "_")
            safeEmail = safeEmail.replacingOccurrences(of: "@", with: "_")
            return safeEmail
        }
    }
    


