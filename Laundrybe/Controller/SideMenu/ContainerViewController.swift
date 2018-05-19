//
//  ContainerViewController.swift
//  Laundrybe
//
//  Created by Sukumar Anup Sukumaran on 28/11/17.
//  Copyright © 2017 Sukumar Anup Sukumaran. All rights reserved.
//

import UIKit
import SidebarOverlay



class ContainerViewController: SOContainerViewController {
    
    
    var sideMenuViewAssigned:Bool?
     var sideMenuV2:Bool = false
    
   
    
    override var isSideViewControllerPresented: Bool {
        
        didSet {
            
            
            let action = isSideViewControllerPresented ? "opened" : "closed"
            let side = self.menuSide == .left ? "left" : "right"
           NSLog("You've \(action) the \(side) view controller.")
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        self.menuSide = .left
       

        
         self.topViewController = self.storyboard?.instantiateViewController(withIdentifier: "HomeMainViewController")
        
        self.sideViewController = self.storyboard?.instantiateViewController(withIdentifier: "LeftMenuViewController")
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
      
       
        print("viewWillAppear - WORKS")
    }
    

    override var preferredStatusBarStyle: UIStatusBarStyle{
    
        return .lightContent
    }
    
      @IBAction func unwindToMenu(segue: UIStoryboardSegue) {
        print("Working here")
         self.topViewController = self.storyboard?.instantiateViewController(withIdentifier: "HomeMainViewController")
        
    }


}
