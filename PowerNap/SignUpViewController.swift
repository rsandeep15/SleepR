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

class SignUpViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    
    @IBOutlet weak var agePicker: UIPickerView!
    @IBOutlet weak var firstName: UITextField!

    @IBOutlet weak var lastName: UITextField!
    
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var confirmPass: UITextField!
    
    @IBOutlet weak var errorMessage: UILabel!
    let auth = FIRAuth.auth()
    let dbRef = FIRDatabase.database().reference()
    var ages: [String] = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeAges()
        agePicker.delegate = self
        agePicker.dataSource = self
        agePicker.reloadAllComponents()
        
        
        // Do any additional setup after loading the view.
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
        if (firstName.text! == "" || lastName.text! == "") {
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
        // Check if passwords match
        if (password.text != confirmPass.text) {
            errorMessage.text = "Passwords do not match"
            return false
        }
       
        return true
    }
    
    
    @IBAction func signUp(_ sender: UIButton) {
        if (validateForm()) {
            auth?.createUser(withEmail: email.text!, password: password.text!, completion: { (user: FIRUser?, error: Error?) in
                if let user = user {
                    let changeRequest = user.profileChangeRequest()
                    // Set the display name of the user
                    let firstNameText: String = self.firstName.text ?? "John"
                    changeRequest.displayName = firstNameText
                    
                    let lastNameText: String = self.lastName.text ?? "Smith"
                    let emailText: String = self.email.text ?? "testuser@email.com"
                    // Get the selected age from the UIPickerView
                    let age = self.ages[self.agePicker.selectedRow(inComponent: 0)]
                    
                    User.addUser(useruid: user.uid, firstName: firstNameText, lastName: lastNameText, email: emailText, age: age)
                    
                    self.performSegue(withIdentifier: "signUpSegue", sender: self)
                }
                if let error = error {
                    self.errorMessage.text = error.localizedDescription
                }
            })
        }
        
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return ages[row]
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return ages.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
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
