//
//  ViewController.swift
//  PowerNap
//
//  Created by Sandeep Raghunandhan on 3/24/17.
//  Copyright © 2017 Sandeep Raghunandhan. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    @IBOutlet weak var email: UITextField!

    @IBOutlet weak var password: UITextField!
    
    let auth: FIRAuth = FIRAuth.auth()!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func validateForm() -> Bool {
        if (email.text == "" || password.text == "" ) {
            return false
        }
        return true
    }
    
    
    @IBAction func login(_ sender: Any){
        if (validateForm()) {
            auth.signIn(withEmail: email.text!, password: password.text!, completion: { (user: FIRUser?, error: Error?) in
                if let user = user {
                    print("Logged In as \(user.displayName)")
                    self.performSegue(withIdentifier: "loginSegue", sender: self)
                }
                if let error = error {
                    print(error.localizedDescription)
                }
            })
        }
    }


}

