//
//  LnchViewController.swift
//  Laundrybe
//
//  Created by Sukumar Anup Sukumaran on 02/01/18.
//  Copyright © 2018 Sukumar Anup Sukumaran. All rights reserved.
//

import UIKit

class LnchViewController: UIViewController {
    
    
    @IBOutlet weak var centerConstrains: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.centerConstrains.constant = 0
        UIView.animate(withDuration: 2.0, animations: self.view.layoutIfNeeded) { _ in
            
            self.NewCall()
            
        }
    }
    
    
    func NewCall() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            print("LAunchShowninTimer")
            
            if  UserDefaults.standard.object(forKey: "RegSuccess") != nil || UserDefaults.standard.object(forKey: "LoginSuccess") != nil{
                
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ContainerViewController") as! ContainerViewController
                
                self.present(vc, animated: false, completion: nil)
                print("IndismissIfCon")
           
            }else{
                
                print("IndismissElseCon")
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                self.present(vc, animated: false, completion: nil)
                
                
            }
    
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    deinit {
        print("LaunchScreen Deinited")
    }
}
