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

class TipsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIGestureRecognizerDelegate {

    let auth: FIRAuth = FIRAuth.auth()!
    let dbRef = FIRDatabase.database().reference()
    
    @IBOutlet weak var tipsCollection: UICollectionView!
    var tips:[Tip] = []
    var autofetch = true;
    @IBOutlet weak var tipbackground: UIImageView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tipPanGesture = UIPanGestureRecognizer(target: self, action: #selector(tipSwiped))
        tipsCollection.dataSource = self
        tipsCollection.delegate = self
        tipPanGesture.delegate = self
        self.view.addGestureRecognizer(tipPanGesture)
        fetchTips()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tipbackground.alpha = 0
        UIView.animate(withDuration: 0.4, animations: {() -> Void in
            self.tipbackground.alpha = 1
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchTips() {
        dbRef.child("tips").observe(.value) { (snap: FIRDataSnapshot) in
            if self.autofetch {
                self.tips = []
                for tipShot in snap.children {
                    let snapshot = tipShot as! FIRDataSnapshot
                    let tipEntry = snapshot.value as! NSDictionary
                    
                    let tip = Tip(idx: snapshot.key, text: (tipEntry.value(forKeyPath: "description") as? String)!, source: tipEntry.value(forKey: "source") as? String)
                    self.tips.append(tip)
                    self.tipsCollection.reloadData()
                }
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
    
    // When a tip cell is tapped, open the URL from where the tip was fetched
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let tipCell = tipsCollection.cellForItem(at: indexPath) as! TipCell
        let tipURL = URL(string: tipCell.tip?.source ?? "No URL")
        if let tipURL = tipURL {
            if UIApplication.shared.canOpenURL(tipURL) {
                UIApplication.shared.open(tipURL, options: [:], completionHandler: nil)
            }
        }
    }
    
    func tipSwiped(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: self.tipsCollection)
        
        let location: CGPoint = sender.location(in: tipsCollection)
        let swipedIndexPath = tipsCollection.indexPathForItem(at: location)
        if let path = swipedIndexPath {
            let cell = tipsCollection.cellForItem(at: path) as? TipCell
            if let cell = cell {
                let tipState = sender.state
                let ogCenter = cell.center.x
                if tipState == .began {
                    cell.center.x = view.center.x
                }
                if tipState == .changed {
                    if translation.x < 0 {
                        cell.center.x = ogCenter + translation.x
                        sender.setTranslation(CGPoint(x: 0.0, y: 0.0), in: self.view)
                    }
                }
                if tipState == .ended {
                    if cell.center.x < CGFloat(45) {
                        cell.center.x = view.center.x
                        tips.remove(at: path.row)
                        tipsCollection.reloadData()
                        self.autofetch = false
                        DispatchQueue.global(qos: .background).async {
                            Tip.removeTip(id: cell.tip.index!, completion: { (result: String) in
                                self.autofetch = true
                            })
                        }
     
                    }
                    else {
                        cell.center.x = view.center.x
                    }
                    sender.setTranslation(CGPoint(x: 0.0, y: 0.0), in: self.view)
                }
            }
        }
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    @IBAction func onAdd(_ sender: Any) {
        self.performSegue(withIdentifier: "addTip", sender: nil)
    }

}
