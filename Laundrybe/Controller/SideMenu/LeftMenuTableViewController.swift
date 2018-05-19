//
//  LeftMenuTableViewController.swift
//  Laundrybe
//
//  Created by Sukumar Anup Sukumaran on 28/11/17.
//  Copyright © 2017 Sukumar Anup Sukumaran. All rights reserved.
//

import UIKit

class LeftMenuTableViewController: UITableViewController {

    @IBOutlet var sideMenuTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        print("Works")
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            
            if let container = self.so_containerViewController {
                container.isSideViewControllerPresented = false
            }
            
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeMainViewController")
            
            
            self.so_containerViewController?.topViewController = vc
            
           
            
        }
        
        if indexPath.row == 1 {
            
            if let container = self.so_containerViewController {
                container.isSideViewControllerPresented = false
            }
            
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MyOrdersListViewController")
            
            
            self.so_containerViewController?.topViewController = vc
            
           
            
        }
        if indexPath.row == 2{
            
            if let container = self.so_containerViewController {
                container.isSideViewControllerPresented = false
            }
            
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProfilePageViewController")
            
            
            self.so_containerViewController?.topViewController = vc
            
            
        }
        
        
        if indexPath.row == 3{
            
            if let container = self.so_containerViewController {
                container.isSideViewControllerPresented = false
            }
            
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OffersViewController")
            
            self.so_containerViewController?.topViewController = vc
            
            
        }
        
        
        if indexPath.row == 5 {
            
            if let container = self.so_containerViewController {
                container.isSideViewControllerPresented = false
            }
            
            let shareInSocialMedia = UIActivityViewController(activityItems: ["""
Let me recommend you this application
https://itunes.apple.com/in/app/laundrybe/id1335930898?mt=8
"""], applicationActivities: nil)
            
            
            self.present(shareInSocialMedia, animated: true, completion: nil)
        }
        
        if indexPath.row == 6 {
            
            if let container = self.so_containerViewController {
                container.isSideViewControllerPresented = false
            }
            
            let url = NSURL(string: "mailto:radviewtechnologies@gmail.com?subject=MySmartLaundryFeedback")
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url! as URL)
            } else {
                UIApplication.shared.openURL(url! as URL)
                // Fallback on earlier versions
            }
            
        }
        
        if indexPath.row == 7 {
            //PrivacyWebViewController

            if let container = self.so_containerViewController {
                container.isSideViewControllerPresented = false
            }
            
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PrivacyWebViewController")
            
            self.so_containerViewController?.topViewController = vc
            
            
        }
        
        
    }
    
   

}
