//
//  JournalEntry.swift
//  SleepR
//
//  Created by Sandeep Raghunandhan on 5/7/17.
//  Copyright © 2017 Sandeep Raghunandhan. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
class JournalEntry: NSObject {
    var entryText: String?
    var date: Date?
    var humanReadableDate: String?
    static var currentUserUid = FIRAuth.auth()?.currentUser?.uid
    
    static let DBRef = FIRDatabase.database().reference()
    
    
    init(text: String, date: Date) {
        super.init()
        self.entryText = text
        self.date = date
        self.humanReadableDate = JournalEntry.formatDate(date: date)
    }
    
    class func formatDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.dateFormat = "MMM d, yyyt"
        return formatter.string(from: date)
    }
    
    class func addEntry(entry: JournalEntry) {
        let journalRef = DBRef.child("users").child(currentUserUid!).child("journal")
        journalRef.childByAutoId().setValue(["text" : entry.entryText, "date" : "\(entry.date!.timeIntervalSince1970)"])
    }
}
