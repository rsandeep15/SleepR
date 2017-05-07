//
//  MainViewController.swift
//  PowerNap
//
//  Created by Sandeep Raghunandhan on 3/24/17.
//  Copyright © 2017 Sandeep Raghunandhan. All rights reserved.
//

import UIKit
import FirebaseAuth
import FBSDKLoginKit
import AVFoundation
import UserNotifications

class JournalViewController: UIViewController
, UICollectionViewDataSource, UICollectionViewDelegate{
    
    @IBOutlet weak var noEntriesDisplay: UILabel!
    @IBOutlet weak var journalCollection: UICollectionView!
    var journalEntries:[JournalEntry]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        journalCollection.delegate = self
        journalCollection.dataSource = self
        
        // Do any additional setup after loading the view.
        // format the button
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchEntries() {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let journalEntries = journalEntries {
            noEntriesDisplay.alpha = 0
            return journalEntries.count
        }
        else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = journalCollection.dequeueReusableCell(withReuseIdentifier: "entryCell", for: indexPath) as? EntryCell
        
        cell?.entry = journalEntries?[indexPath.row]
        
        return cell!
    }
    
}
