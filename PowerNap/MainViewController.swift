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
import UserNotifications

class MainViewController: UIViewController, AVAudioPlayerDelegate{
    
    var timeMin = 20;
    var timeSec = 0;
    
    var startTime: Double = 0;
    
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
        // Only perform the segue if the user has been properly logged out
        if (auth.currentUser == nil) {
            return true
        }
        else {
            return false
        }
    }
    
    @IBAction func onStart(_ sender: Any) {
        // Instantiate a timer object if one has not been created yet
        if timer != nil {
            // Do Nothing. Singleton Pattern.
        }
        else {
            startTime = NSDate().timeIntervalSince1970
            // Timer calls the decrement time method every second.
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(decrementTime), userInfo: nil, repeats: true)
            
            // Setup notification 
            let content = UNMutableNotificationContent()
            content.title = "Power Nap"
            content.body = "Rise and Shine! Your nap has ended"
            content.sound = UNNotificationSound.default()
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 20*60, repeats: false)
            
            // Schedule the notification
            let request = UNNotificationRequest(identifier: "alarm", content: content, trigger: trigger)
            let center = UNUserNotificationCenter.current()
            center.add(request, withCompletionHandler: nil)
        }
        
    }
    
    func decrementTime() {
        let currentTime = NSDate().timeIntervalSince1970
        
        print("Start Time: \(startTime)")
        print("Current Time: \(currentTime)")
        // Case to count down the minute
        if (timeSec == 0) {
            timeMin = 20 - (Int(currentTime - startTime))/60 - 1
            timeSec = 59;
        }
        // Decrement the second
        else {
            timeSec = 59 - (Int(currentTime - startTime) % 60);
        }
        // When the time hits 0, play the alarm sound
        if (timeSec <= 0 && timeMin <= 0) {
//            playAlarm()
            let alert = UIAlertController(title: "Alarm", message: "Your nap has ended. Rise and shine!", preferredStyle: UIAlertControllerStyle.alert)
            let stopAction = UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: { (action: UIAlertAction) in
                // Turn off the alarm
//                self.player.stop()
            })
            alert.addAction(stopAction)
            
            // Show the alarm
            self.present(alert, animated: true, completion: {
            })
            
            resetTimer()
        }
        // Add leading 0 to time (when less than 10 seconds)
        if (timeSec < 10 ) {
            timeLeft.text = "\(timeMin) : 0\(timeSec)"
            return
        }
        // Update the time displayed
        timeLeft.text = "\(timeMin) : \(timeSec)"
    }
    
    // Reset the time to 20 mins
    @IBAction func onCancel(_ sender: Any) {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        resetTimer()
    }
    
    func resetTimer() {
        if let timer = timer {
            timer.invalidate()
            self.timer = nil
            // Reset timer
            timeLeft.text = "20 : 00"
            timeMin = 20
            timeSec = 0
            startTime = 0
        }
    }
    
    func playAlarm() {
        do {
            // Using a mp3 created on GarageBand
            let powerNapFile: String = Bundle.main.path(forResource: "PowerNapAlarm", ofType: "mp3")!
            self.player = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: powerNapFile))
            // Keep playing the file infinitely
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
