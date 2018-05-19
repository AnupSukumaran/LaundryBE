//
//  OffersViewController.swift
//  Laundrybe
//
//  Created by Sukumar Anup Sukumaran on 19/12/17.
//  Copyright © 2017 Sukumar Anup Sukumaran. All rights reserved.
//

import UIKit
import SDWebImage
import NVActivityIndicatorView

class OffersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NVActivityIndicatorViewable {
    
    
    @IBOutlet weak var offerTableView: UITableView!
    
    var providersAPI = APIService()
    
    
    var couponData = [CouponDataModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.tintColor = UIColor.white
        let fontDictionary = [ NSAttributedStringKey.foregroundColor:UIColor.white, NSAttributedStringKey.font: UIFont(name: "Arial Rounded MT Bold", size: 18.0)!  ]
        
        self.navigationController?.navigationBar.titleTextAttributes = fontDictionary
        self.navigationController?.navigationBar.setBackgroundImage(imageLayerForGradientBackground(), for: UIBarMetrics.default)

        offerTableView.delegate = self
        offerTableView.dataSource = self
         self.startAnimating(message: "", type: NVActivityIndicatorType.ballSpinFadeLoader, color: .white, padding: 5)
        providersAPI.ForOfferApi { (values) in
            
            switch values {
            case .Success(let data):
                self.stopAnimating()
                self.jsonResultParse(data as AnyObject)
            case .Error(let message):
                self.stopAnimating()
                print("Error = \(message)")
            }
            
        }
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
    
    func jsonResultParse(_ json:AnyObject) {
        
        let JSONArray = json as! NSArray
        print("jsonaArray = \(JSONArray)")
        
        if JSONArray.count != 0 {
            
            for i:Int in 0 ..< JSONArray.count {
                
                let jObject = JSONArray[i] as! NSDictionary
                
                let uOffer:CouponDataModel = CouponDataModel()
                uOffer.id = (jObject["id"] as AnyObject? as? String) ?? ""
                uOffer.title = (jObject["title"] as AnyObject? as? String) ?? ""
                uOffer.banner = (jObject["banner"] as AnyObject? as? String) ?? ""
                uOffer.code = (jObject["code"] as AnyObject? as? String) ?? ""
                uOffer.percentage = (jObject["percentage"] as AnyObject? as? String) ?? ""
                uOffer.expiry = (jObject["expiry"] as AnyObject? as? String) ?? ""
                uOffer.last_updated_date = (jObject["last_updated_date"] as AnyObject? as? String) ?? ""
                
                couponData.append(uOffer)

            }
            
            self.offerTableView.reloadData()
        }
    }
    
    
    
    @IBAction func MenuButton(_ sender: UIBarButtonItem) {
        
        if let container = self.so_containerViewController {
            container.isSideViewControllerPresented = true
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return couponData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OffersTableViewCell", for: indexPath) as! OffersTableViewCell
        
        let imageUrl = couponData[indexPath.row].banner
        print("ImageUrl = \(imageUrl)")
        cell.imageBanner.sd_setImage(with: URL(string: imageUrl))
        cell.promoCode.text = couponData[indexPath.row].code
        cell.titleDiscLabel.text = couponData[indexPath.row].title + "  " + couponData[indexPath.row].percentage
        cell.expiryLabel.text = "Expiry: " + couponData[indexPath.row].expiry
        
        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
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
