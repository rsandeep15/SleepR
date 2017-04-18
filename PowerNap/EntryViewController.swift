//
//  EntryViewController.swift
//  PowerNap
//
//  Created by Sandeep Raghunandhan on 3/27/17.
//  Copyright © 2017 Sandeep Raghunandhan. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FirebaseAuth
import Firebase
class EntryViewController: UIViewController, FBSDKLoginButtonDelegate {

    @IBOutlet weak var FBLoginButton: FBSDKLoginButton!
    var auth: FIRAuth?
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // hide navigation bar on first viewcontroller
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidLoad() {
        auth = FIRAuth.auth()!
        super.viewDidLoad()
        FBLoginButton.delegate = self
        FBLoginButton.readPermissions = ["email", "public_profile", "user_friends", "user_about_me"]
        FBSDKProfile.enableUpdates(onAccessTokenChange: true)
        NotificationCenter.default.addObserver(self, selector: #selector(self.onProfileFetched(notification:)), name: NSNotification.Name.FIRAuthStateDidChange, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        // Do Nothing
    }
    
    /**
     Sent to the delegate when the button was used to login.
     - Parameter loginButton: the sender
     - Parameter result: The results of the login
     - Parameter error: The error (if any) from the login
     */
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        
        if let error = error {
            print(error.localizedDescription)
            return
        }
        
        // Login to Firebase using the FB credential
        let fbcredential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
        auth?.signIn(with: fbcredential) {(user, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            
        }
    }
    
    func onProfileFetched(notification: NSNotification)
    {
        if (auth?.currentUser == nil || FBSDKProfile.current() == nil) {
            return
        }
        let profile = FBSDKProfile.current()!
        let user = auth!.currentUser!
        let userUid = user.uid
        
        let firstName = profile.firstName!
        let lastName = profile.lastName!
        let email = user.email!
        let age = ""
        
        User.addUser(useruid: userUid, firstName: firstName, lastName: lastName, email: email, age: age)
        self.performSegue(withIdentifier: "fbLogin", sender: self)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
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
