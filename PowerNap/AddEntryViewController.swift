//
//  AddEntryViewController.swift
//  SleepR
//
//  Created by Sandeep Raghunandhan on 5/7/17.
//  Copyright © 2017 Sandeep Raghunandhan. All rights reserved.
//

import UIKit

class AddEntryViewController: UIViewController {

    @IBOutlet weak var todaysDate: UILabel!
    @IBOutlet weak var errorMessage: UILabel!
    @IBOutlet weak var textEntered: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        todaysDate.text = JournalEntry.formatDate(date: Date())
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onCancel(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }

    @IBAction func onDone(_ sender: Any) {
        let entry = JournalEntry(text: textEntered.text , date: Date())
        
        if entry.entryText == "" {
            errorMessage.text = "Write something down before you sleep"
        }
        else {
            JournalEntry.addEntry(entry: entry)
            self.presentingViewController?.dismiss(animated: true, completion: nil)
        }
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
