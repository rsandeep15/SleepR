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

    @IBOutlet weak var errorMessage: UILabel!
    @IBOutlet weak var password: UITextField!
    
    let auth: FIRAuth = FIRAuth.auth()!
    
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.layer.cornerRadius = 5
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
        self.navigationItem.title = "Login"
        let Line = CALayer()
        Line.frame = CGRect(x: 0.0, y: email.frame.height - 1, width: email.frame.width, height: 1.0)
        Line.backgroundColor = UIColor.white.cgColor
        
        let Line1 = CALayer()
        Line1.frame = CGRect(x: 0.0, y: email.frame.height - 1, width: email.frame.width, height: 1.0)
        Line1.backgroundColor = UIColor.white.cgColor
        email.layer.addSublayer(Line)
        password.layer.addSublayer(Line1)
        
        let colorAttribute = [NSForegroundColorAttributeName : UIColor.init(colorLiteralRed: 255/255, green: 255/255, blue: 255/255, alpha: 0.7)]
        
        email.attributedPlaceholder = NSAttributedString(string: "Email Address", attributes: colorAttribute)
        password.attributedPlaceholder = NSAttributedString(string: "Password", attributes: colorAttribute)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func validateForm() -> Bool {
        if (email.text == "" || password.text == "" ) {
            errorMessage.text = "Please enter a valid email and password"
            return false
        }
        return true
    }
    
    @IBAction func login(_ sender: Any) {
        if (validateForm()) {
            auth.signIn(withEmail: email.text!, password: password.text!, completion: { (user: FIRUser?, error: Error?) in
                if (user != nil){
                    self.performSegue(withIdentifier: "loginSegue", sender: nil)
                }
                if (error != nil) {
                    self.view.endEditing(true)
                    self.errorMessage.text = "Invalid Password or User Does Not Exist"
                }
            })
        }
        else {
            self.view.endEditing(true)
        }
    }
    
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if (identifier == "loginSegue" && validateForm()) {
            if ((auth.currentUser) != nil) {
                return true;
            }
        }
        return false;
    }

    @IBAction func onForgotPassword(_ sender: Any) {
        self.performSegue(withIdentifier: "forgotPass", sender: nil)
        
    }

}

