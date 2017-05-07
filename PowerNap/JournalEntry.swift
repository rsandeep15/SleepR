//
//  JournalEntry.swift
//  SleepR
//
//  Created by Sandeep Raghunandhan on 5/7/17.
//  Copyright © 2017 Sandeep Raghunandhan. All rights reserved.
//

import UIKit

class JournalEntry: NSObject {
    var entryText: String?
    var date: Date?
    var humanReadableDate: String?
    init(text: String, date: Date) {
        self.entryText = text
        self.date = date
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.dateFormat = "mmm dd, yyyt"
        self.humanReadableDate = formatter.string(from: date)
    }
}
