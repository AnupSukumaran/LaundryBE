//
//  ServiceTypeViewController.swift
//  Laundrybe
//
//  Created by Sukumar Anup Sukumaran on 28/11/17.
//  Copyright © 2017 Sukumar Anup Sukumaran. All rights reserved.
//

import UIKit
import SDWebImage
import NVActivityIndicatorView

class ServiceTypeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NVActivityIndicatorViewable {
    
    
   
    
      var providersAPI = APIService()

    var ServiceValues = [ServiceModel]()
    
    @IBOutlet weak var typeTableItems: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.tintColor = UIColor.white
        let fontDictionary = [ NSAttributedStringKey.foregroundColor:UIColor.white, NSAttributedStringKey.font: UIFont(name: "Arial Rounded MT Bold", size: 18.0)!  ]
        
        self.navigationController?.navigationBar.titleTextAttributes = fontDictionary
        self.navigationController?.navigationBar.setBackgroundImage(imageLayerForGradientBackground(), for: UIBarMetrics.default)
        
        
        
        self.startAnimating(message: "", type: NVActivityIndicatorType.ballSpinFadeLoader, color: .white, padding: 5)
        
        providersAPI.id = globalLabel.sharedInstance.id
        
        callingApi()
     
    }
    func checkReachability(){
        if currentReachabilityStatus == .reachableViaWiFi {
            
            print("User is connected to the internet via wifi.")
            
        }else if currentReachabilityStatus == .reachableViaWWAN{
            
            print("User is connected to the internet via WWAN.")
            
        } else {
            self.stopAnimating()
            
            let alert = UIAlertController(title: "No Internet Connection", message: "Make sure your device is connected to the internet", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }
    }
    
    override func viewDidLayoutSubviews() {
        checkReachability()
    }
    
    func callingApi() {
        
        providersAPI.getDataForServiceType { (result) in
            switch result {
            case .Success(let data):
                self.stopAnimating()
                self.jsonResultParse(data as AnyObject)
            case .Error(let message):
                print("Error = \(message)")
                self.stopAnimating()
            }
            
        }
        
        
    }
    
    func jsonResultParse(_ json:AnyObject) {
        
        let JSONArray = json as! NSArray
        print("jsonaArray = \(JSONArray)")
        
        if JSONArray.count != 0 {
            
            for i:Int in 0 ..< JSONArray.count {
                
                let jObject = JSONArray[i] as! NSDictionary
                
                let uProvider:ServiceModel = ServiceModel()
                uProvider.id = (jObject["id"] as AnyObject? as? String) ?? ""
                uProvider.image = (jObject["image"] as AnyObject? as? String) ?? ""
                uProvider.pro_id = (jObject["pro_id"] as AnyObject? as? String) ?? ""
                uProvider.servicetype = (jObject["servicetype"] as AnyObject? as? String) ?? ""
                ServiceValues.append(uProvider)
                
            }
            
            self.typeTableItems.reloadData()
        }
    }
    
    
    
   

    
    @IBAction func MenuButton(_ sender: UIBarButtonItem) {
  
        if let container = self.so_containerViewController {
            container.isSideViewControllerPresented = true
        }
    
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ServiceValues.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ServiceTypeTableViewCell", for: indexPath) as! ServiceTypeTableViewCell
        
        let imageURL = ServiceValues[indexPath.row].image
       // cell.imageData.sd_setImage(with: URL(string: imageURL))
        cell.imageData.sd_setImage(with: URL(string: imageURL), placeholderImage: UIImage(named: "defalutImage"))
        
        cell.serviceTypeLabel.text = ServiceValues[indexPath.row].servicetype
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //tabBarController
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tabbarVC = storyboard.instantiateViewController(withIdentifier: "TabbarIdentifier") as! UITabBarController
        
        let vcs = tabbarVC.viewControllers
        let nc = vcs?.first as? UINavigationController
        
        let vcData = nc?.topViewController as? PlaceOrderForMenViewController
        vcData?.idVal = ServiceValues[indexPath.row].id
        vcData?.proIdVal = ServiceValues[indexPath.row].pro_id
        
     
        
       
        self.present(tabbarVC, animated: false, completion: nil)
        
    }
    
   
    
    func callHomeView() {
        
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        
        present(vc, animated: true, completion: nil)
        
        
    }
    
    private func imageLayerForGradientBackground() -> UIImage {
        
        var updatedFrame = self.navigationController?.navigationBar.bounds
        // take into account the status bar
        if UIScreen.main.nativeBounds.height == 2436 {
            updatedFrame?.size.height += 50
            print("IphoneX😇")
        }else{
            updatedFrame?.size.height += 20
            print("SomeOther123")
        }
        let layer = GrandientClass.gradientLayerForBounds(bounds: updatedFrame!)
        UIGraphicsBeginImageContext(layer.bounds.size)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    

}


