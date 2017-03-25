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
    
    let auth = FIRAuth.auth()
    let dbRef = FIRDatabase.database().reference()
    var ages: [String] = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for index in 1...100 {
            ages.append("\(index)")
        }
        agePicker.delegate = self
        agePicker.dataSource = self
        agePicker.reloadAllComponents()
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func validateForm() -> Bool {
        if (firstName.text! == "" || lastName.text! == "") {
            return false
        }
        // Check if password fields match
        if (password.text == "" && confirmPass.text == "" && password.text != confirmPass.text) {
            return false
        }
       
        return true
    }
    
    
    @IBAction func signUp(_ sender: UIButton) {
        if (validateForm()) {
            auth?.createUser(withEmail: email.text!, password: password.text!, completion: { (user: FIRUser?, error: Error?) in
                if let user = user {
                    let changeRequest = user.profileChangeRequest()
                    
                    
                    let firstNameText: String = self.firstName.text ?? "John"
                    let lastNameText: String = self.lastName.text ?? "Smith"
                    let emailText: String = self.email.text ?? "testuser@email.com"
                    // Get the selected age from the UIPickerView
                    let age = self.ages[self.agePicker.selectedRow(inComponent: 0)]
                    
                    // Set the display name of the user
                    changeRequest.displayName = firstNameText
                    // Add the user to the database of user with age, email, firstname, lastname 
                    self.dbRef.child("users").child(user.uid).setValue(["firstName": firstNameText, "lastName": lastNameText, "email": emailText, "age": age])
                    
                    self.performSegue(withIdentifier: "signUpSegue", sender: self)
                }
                if let error = error {
                    print(error.localizedDescription)
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
