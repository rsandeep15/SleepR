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
import FirebaseDatabase

class JournalViewController: UIViewController
, UICollectionViewDataSource, UICollectionViewDelegate{
    
    @IBOutlet weak var noEntriesDisplay: UILabel!
    @IBOutlet weak var journalCollection: UICollectionView!
    var currentUserUid: String = (FIRAuth.auth()?.currentUser?.uid)!
    var journalEntries:[JournalEntry]?
    var dbRef = FIRDatabase.database().reference()
    var auth = FIRAuth.auth()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        journalCollection.delegate = self
        journalCollection.dataSource = self
        fetchEntries()
        // Do any additional setup after loading the view.
        // format the button
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func deleteEntry(_ sender: UITapGestureRecognizer) {
        
        let location: CGPoint = sender.location(in: journalCollection)
        let tappedIndexPath = journalCollection.indexPathForItem(at: location)
        let entry = journalEntries?[(tappedIndexPath?.row)!]
        journalEntries?.remove(at: (tappedIndexPath?.row)!)
        JournalEntry.deleteEntry(entry: entry!)
        journalCollection.reloadData()
        
    }
    
    
    func fetchEntries() {
        dbRef.child("users").child(currentUserUid).child("journal").queryOrdered(byChild: "date").observe(.value) { (snap: FIRDataSnapshot) in
                self.journalEntries = []
                for snap in snap.children {
                    let snapshot = snap as! FIRDataSnapshot
                    let journalEntry = snapshot.value as! NSDictionary
                    let entryText = journalEntry.value(forKey: "text") as! String
                    let dateString = journalEntry.value(forKey: "date") as! String
                    let dateInterval = Double(dateString)
                    let entry = JournalEntry(text: entryText, date: Date(timeIntervalSince1970: dateInterval!))
                    self.journalEntries?.append(entry)
                    print(entryText)
                }
                self.journalEntries = self.journalEntries?.reversed()
                self.journalCollection.reloadData()
        }
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
    @IBAction func onAddEntry(_ sender: Any) {
        
        self.performSegue(withIdentifier: "addEntry", sender: nil)
    }
    @IBAction func onLogout(_ sender: Any) {
        do {
            // logout a facebook user
            if (FBSDKAccessToken.current() != nil) {
                FBSDKAccessToken.setCurrent(nil)
            }
            
            // logout the firebase user
            try auth?.signOut()
            self.performSegue(withIdentifier: "logout", sender: nil)
        }
        catch FIRAuthErrorCode.errorCodeKeychainError {
            print("Key chain error")
        }
        catch let error {
            print(error.localizedDescription)
        }
    }
    
}
