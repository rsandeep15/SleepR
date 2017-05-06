//
//  Tip.swift
//  PowerNap
//
//  Created by Sandeep Raghunandhan on 3/28/17.
//  Copyright © 2017 Sandeep Raghunandhan. All rights reserved.
//

import UIKit
import FirebaseDatabase
class Tip: NSObject {
    var index: String?
    var textDescription: String?
    var source: String?
    static let DBRef = FIRDatabase.database().reference()
    class func addTip(tip: String, useruid: String) {
        let tipId = DBRef.child("tips").childByAutoId().key
        DBRef.child("users").child(useruid).child("Name").observeSingleEvent(of: .value) { (snap: FIRDataSnapshot) in
            let username = snap.value
            DBRef.child("tips").child(tipId).setValue(["description" : tip, "source" : username])
        }
    }
}
