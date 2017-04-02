//
//  MainViewController.swift
//  PowerNap
//
//  Created by Sandeep Raghunandhan on 3/24/17.
//  Copyright © 2017 Sandeep Raghunandhan. All rights reserved.
//

import UIKit
import FirebaseAuth
import FBSDKLoginKit
import AVFoundation

class MainViewController: UIViewController, AVAudioPlayerDelegate {
    
    var timeMin = 20;
    var timeSec = 0;
    
    @IBOutlet weak var timeLeft: UILabel!
    @IBOutlet weak var startButton: UIButton!
 
    @IBOutlet weak var cancelButton: UIButton!
    
    var timer: Timer?
    
    let auth: FIRAuth = FIRAuth.auth()!
    
    var player = AVAudioPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // format the button 
        startButton.layer.cornerRadius = 40
        cancelButton.layer.cornerRadius = 40
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    @IBAction func onStart(_ sender: Any) {
        if let timer = timer {
            // Do Nothing 
        }
        else {
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(decrementTime), userInfo: nil, repeats: true)
        }
        
    }
    
    func decrementTime() {
        if (timeSec == 0) {
            timeMin -= 1;
            timeSec = 59;
        }
        else {
            timeSec -= 1;
        }
        
        if (timeSec <= 0 && timeMin <= 0) {
            playAlarm()
            let alert = UIAlertController(title: "Alarm", message: "Your nap has ended. Rise and shine!", preferredStyle: UIAlertControllerStyle.alert)
            let stopAction = UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: { (action: UIAlertAction) in
                // Turn off the alarm
                self.player.stop()
            })
            alert.addAction(stopAction)
            self.present(alert, animated: true, completion: {
            })
            
            resetTimer()
        }
        
        if (timeSec < 10 ) {
            timeLeft.text = "\(timeMin) : 0\(timeSec)"
            return
        }
        
        
        timeLeft.text = "\(timeMin) : \(timeSec)"
    }
    
    @IBAction func onCancel(_ sender: Any) {
        resetTimer()
    }
    
    func resetTimer() {
        if let timer = timer {
            timer.invalidate()
            self.timer = nil
            // Reset timer
            timeLeft.text = "20 : 00"
            timeMin = 20;
            timeSec = 0;
        }
    }
    
    func playAlarm() {
        do {
            let powerNapFile: String = Bundle.main.path(forResource: "PowerNapAlarm", ofType: "mp3")!
            self.player = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: powerNapFile))
            player.numberOfLoops = -1
            player.volume = 5
            player.prepareToPlay()
            player.delegate = self
            player.play()
        }
        catch let error {
            print(error.localizedDescription)
        }
    }
    

}
