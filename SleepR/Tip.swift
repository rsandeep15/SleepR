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
    
    init(idx: String, text: String, source: String?) {
        super.init()
        self.index = idx
        self.textDescription = text
        self.source = source
    }
    
    
    class func addTip(tip: String, useruid: String) {
        let tipId = DBRef.child("tips").childByAutoId().key
        DBRef.child("users").child(useruid).child("Name").observeSingleEvent(of: .value) { (snap: FIRDataSnapshot) in
            let username = snap.value
            DBRef.child("tips").child(tipId).setValue(["description" : tip, "source" : username])
        }
    }
    class func removeTip(id: String, completion: @escaping (_ result: String)->()) {
        DBRef.child("tips").child(id).removeValue { (error: Error?, db: FIRDatabaseReference) in
            completion("Success")
        }
    }
}
