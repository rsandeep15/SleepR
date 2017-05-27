//
//  SignUpViewController.swift
//  PowerNap
//
//  Created by Sandeep Raghunandhan on 3/24/17.
//  Copyright © 2017 Sandeep Raghunandhan. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class SignUpViewController: UIViewController {
  
    @IBOutlet weak var nameText: UITextField!
    
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var errorMessage: UILabel!
    let auth = FIRAuth.auth()
    let dbRef = FIRDatabase.database().reference()
    var ages: [String] = []
    
    @IBOutlet weak var signUpButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
        self.navigationItem.title = "Sign Up"
        
        // Do any additional setup after loading the view.
        signUpButton.layer.cornerRadius = 5
        
        let emailLine = CALayer()
        emailLine.frame = CGRect(x: 0.0, y: email.frame.height - 1, width: email.frame.width, height: 1.0)
        emailLine.backgroundColor = UIColor.white.cgColor
        
        let passLine = CALayer()
        passLine.frame = CGRect(x: 0.0, y: password.frame.height - 1, width: password.frame.width, height: 1.0)
        passLine.backgroundColor = UIColor.white.cgColor
        
        let nameLine = CALayer()
        nameLine.frame = CGRect(x: 0.0, y: nameText.frame.height - 1, width: nameText.frame.width, height: 1.0)
        nameLine.backgroundColor = UIColor.white.cgColor
        
        
        email.layer.addSublayer(emailLine)
        password.layer.addSublayer(passLine)
        nameText.layer.addSublayer(nameLine)
        
        
        let colorAttribute = [NSForegroundColorAttributeName : UIColor.init(colorLiteralRed: 255/255, green: 255/255, blue: 255/255, alpha: 1)]
        
        email.attributedPlaceholder = NSAttributedString(string: "Email Address", attributes:colorAttribute)
        password.attributedPlaceholder = NSAttributedString(string: "Password", attributes:colorAttribute)
        nameText.attributedPlaceholder = NSAttributedString(string: "Name", attributes: colorAttribute)
        
        
    }
    
    func initializeAges() {
        for index in 1...100 {
            ages.append("\(index)")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func validateForm() -> Bool {
        // Check if names were entered
        if (nameText.text! == "") {
            errorMessage.text = "Please enter a valid name"
            return false
        }
        // Check if email was entered
        if (email.text == "") {
            errorMessage.text = "Please enter a valid email"
            return false;
        }
        // Check if password fields were entered
        if (password.text == "" ){
            errorMessage.text = "Please enter a valid password"
            return false
        }
       
        return true
    }
    
    
    @IBAction func dismissKeyboard(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    @IBAction func signUp(_ sender: UIButton) {
        if (validateForm()) {
            auth?.createUser(withEmail: email.text!, password: password.text!, completion: { (user: FIRUser?, error: Error?) in
                if let user = user {
                    let changeRequest = user.profileChangeRequest()
                    // Set the display name of the user
                    let firstNameText: String = self.nameText.text ?? "John"
                    changeRequest.displayName = firstNameText
                    
                    let emailText: String = self.email.text ?? "testuser@email.com"
                    // Get the selected age from the UIPickerView
                    
                    User.addUser(useruid: user.uid, name: firstNameText, email: emailText)
                    
                    self.performSegue(withIdentifier: "signUpSegue", sender: self)
                }
                if let error = error {
                    self.view.endEditing(true)
                    self.errorMessage.text = error.localizedDescription
                }
            })
        }
        else {
            self.view.endEditing(true)
        }
        
    }


}
