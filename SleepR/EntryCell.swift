//
//  EntryCell.swift
//  SleepR
//
//  Created by Sandeep Raghunandhan on 5/7/17.
//  Copyright © 2017 Sandeep Raghunandhan. All rights reserved.
//

import UIKit

class EntryCell: UICollectionViewCell {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var textEntryView: UITextView!
    
    
    var entry: JournalEntry! {
        didSet {
            if let dateText = entry.humanReadableDate {
                dateLabel.text = dateText
            }
            if let entryText = entry.entryText {
                textEntryView.text = entryText
            }
        }
    }
}
