//
//  InfoViewController.swift
//  ChildCarSafety
//
//  Created by Jamee Krzanich on 11/27/18.
//  Copyright © 2018 RedBear. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController {

    @IBOutlet weak var acknowledgmentsButton: UIButton!
    @IBOutlet weak var liabilityButton: UIButton!
    
    @IBAction func AcknowledgmentsClicked(_ sender: Any) {
        //performSegue(withIdentifier: "AcknowledgmentsSegue", sender: self)
    }
    
    @IBAction func liabilityClicked(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
