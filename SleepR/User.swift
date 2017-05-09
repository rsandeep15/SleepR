//
//  User.swift
//  PowerNap
//
//  Created by Sandeep Raghunandhan on 3/27/17.
//  Copyright © 2017 Sandeep Raghunandhan. All rights reserved.
//

import UIKit
import FirebaseDatabase
class User: NSObject {
    static let dbRef = FIRDatabase.database().reference()
    class func addUser(useruid: String, name: String, email: String) {
        
        
        dbRef.child("users").child(useruid).observeSingleEvent(of: .value) { (snap: FIRDataSnapshot) in
            if snap.exists() {
                // if the user already exists, don't add them again
                return
            }
            else {
                // Add the user to the database of user with age, email, firstname, lastname
                dbRef.child("users").child(useruid).setValue(["Name": name, "email": email])
            }
        }
    }
}
