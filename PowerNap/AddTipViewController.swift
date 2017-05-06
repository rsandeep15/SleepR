//
//  AddTipViewController.swift
//  PowerNap
//
//  Created by Sandeep Raghunandhan on 5/5/17.
//  Copyright © 2017 Sandeep Raghunandhan. All rights reserved.
//

import UIKit
import FirebaseAuth

class AddTipViewController: UIViewController {
    @IBOutlet weak var tipText: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        tipText.contentInset = UIEdgeInsetsMake(-60,0,0,0);
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelled(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true, completion: {
            
        })
    }
    @IBAction func addTip(_ sender: Any) {
        
        self.presentingViewController?.dismiss(animated: true, completion: {
            Tip.addTip(tip: self.tipText.text, useruid: (FIRAuth.auth()?.currentUser?.uid)!)
        })
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
