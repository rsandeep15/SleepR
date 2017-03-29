//
//  TipsViewController.swift
//  PowerNap
//
//  Created by Sandeep Raghunandhan on 3/28/17.
//  Copyright © 2017 Sandeep Raghunandhan. All rights reserved.
//

import UIKit
import FirebaseAuth
import FBSDKLoginKit
import FirebaseDatabase

class TipsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    let auth: FIRAuth = FIRAuth.auth()!
    let dbRef = FIRDatabase.database().reference()
    
    @IBOutlet weak var tipsCollection: UICollectionView!
    var tips:[Tip] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tipsCollection.dataSource = self
        fetchTips()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchTips() {
        dbRef.child("tips").observe(.value) { (snap: FIRDataSnapshot) in
            for tipShot in snap.children {
                let snapshot = tipShot as! FIRDataSnapshot
                let tipEntry = snapshot.value as! NSDictionary
                
                let tip = Tip()
                tip.textDescription = tipEntry.value(forKeyPath: "description") as? String
                tip.source = tipEntry.value(forKey: "source") as? String
                self.tips.append(tip)
                self.tipsCollection.reloadData()
            }
        }
    }
    
    
    @IBAction func logout(_ sender: Any) {
        do {
            // logout a facebook user
            if (FBSDKAccessToken.current() != nil) {
                FBSDKAccessToken.setCurrent(nil)
            }
            
            // logout the firebase user
            try auth.signOut()
            self.performSegue(withIdentifier: "logout", sender: nil)
        }
        catch FIRAuthErrorCode.errorCodeKeychainError {
            print("Key chain error")
        }
        catch let error {
            print(error.localizedDescription)
        }
    }
    
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if (auth.currentUser == nil) {
            return true
        }
        else {
            return false
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tips.count
    
    }
    

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let tipCell = tipsCollection.dequeueReusableCell(withReuseIdentifier: "tipCell", for: indexPath) as! TipCell
        tipCell.tip = tips[indexPath.row]
        
        return tipCell
    }
    

}