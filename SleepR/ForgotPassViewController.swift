//
//  ForgotPassViewController.swift
//  SleepR
//
//  Created by Sandeep Raghunandhan on 5/8/17.
//  Copyright © 2017 Sandeep Raghunandhan. All rights reserved.
//

import UIKit
import FirebaseAuth


class ForgotPassViewController: UIViewController {

    @IBOutlet weak var forgotPassButton: UIButton!
    @IBOutlet weak var firebaseEmail: UITextField!
    @IBOutlet weak var errorMessage: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        forgotPassButton.layer.cornerRadius = 5
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
        self.navigationItem.title = "Forgot Password"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func onReset(_ sender: Any) {
        if firebaseEmail.text != "" {
            let email = firebaseEmail.text!
            FIRAuth.auth()?.sendPasswordReset(withEmail: email, completion: { (error: Error?) in
                if error != nil {
                    // display the error message below
                    self.errorMessage.text = "User does not exist"
                }
                else {
                    // Alert the user that the password reset link has been sent to their email
                    let alertController: UIAlertController = UIAlertController(title: "Password Reset", message: "Check your email (\(email)) for the password reset link.", preferredStyle: UIAlertControllerStyle.alert)
                    let alertAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (done: UIAlertAction) in
                        // Once acknowledged, navigate back to login screen
                        self.navigationController?.popViewController(animated: true)
                    })
                    alertController.addAction(alertAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            })
        }
        else {
            self.errorMessage.text = "Please enter a valid email"
        }
    }

}