//
//  LeftMenuViewController.swift
//  Laundrybe
//
//  Created by Sukumar Anup Sukumaran on 28/11/17.
//  Copyright © 2017 Sukumar Anup Sukumaran. All rights reserved.
//

import UIKit

class LeftMenuViewController: UIViewController {
    
    
    @IBOutlet weak var userLabel: UILabel!
    
    @IBOutlet weak var gmailLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        userLabel.text = UserDefaults.standard.object(forKey: "UserName") as? String
        gmailLabel.text = UserDefaults.standard.object(forKey: "EmailKey") as? String
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
