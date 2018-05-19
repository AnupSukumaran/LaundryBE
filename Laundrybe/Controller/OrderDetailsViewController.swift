//
//  OrderDetailsViewController.swift
//  Laundrybe
//
//  Created by Sukumar Anup Sukumaran on 21/12/17.
//  Copyright © 2017 Sukumar Anup Sukumaran. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class OrderDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NVActivityIndicatorViewable{
    
    var orderData = [orderDataNewModel]()
    var providerApi = APIService()
    var orderID = ""
    
    var totVar = 0
    var totQuantity = 0
    var surCharge = ""
    var promoAmt = ""
    var GrandTot = ""
    var totTotal = ""
    
    
    @IBOutlet weak var totalLabel: UILabel!
    
    @IBOutlet weak var qtyLabel: UILabel!
    
    @IBOutlet weak var discountLabel: UILabel!
    
    @IBOutlet weak var surChargeLabel: UILabel!
    
    @IBOutlet weak var grandTotalLabel: UILabel!
    
    @IBOutlet weak var orderDetailTableView: UITableView!
    @IBOutlet weak var TotalLabelLength: NSLayoutConstraint!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.tintColor = UIColor.white
        let fontDictionary = [ NSAttributedStringKey.foregroundColor:UIColor.white, NSAttributedStringKey.font: UIFont(name: "Arial Rounded MT Bold", size: 18.0)!  ]
        
        self.navigationController?.navigationBar.titleTextAttributes = fontDictionary
        self.navigationController?.navigationBar.setBackgroundImage(imageLayerForGradientBackground(), for: UIBarMetrics.default)

        providerApi.OrderId = orderID
        print("Surcharge = \(surCharge)")
        print("PromoAMt = \(promoAmt)")
        callingUrl()
        
        if UIScreen.main.nativeBounds.height == 2732{
            TotalLabelLength.constant = 575
        }else if  UIScreen.main.nativeBounds.height == 2224 {
            TotalLabelLength.constant = 479
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
    
    
    func callingUrl() {
        self.startAnimating(message: "", type: NVActivityIndicatorType.ballSpinFadeLoader, color: .white, padding: 5)
        providerApi.orderDataDetails { (values) in
            
            switch values {
            case .Success(let data):
                print("OrderId  = \(data)")
                self.jsonResultParse(data as AnyObject)
                self.stopAnimating()
                print("Finifshed")
                self.updateBottomValues()
            case .Error(let message):
                print("Errororr = \(message)")
                self.stopAnimating()
            }
            
            
            
        }
    }
    
    func jsonResultParse(_ json:AnyObject) {
        
        let JSONArray = json as! NSArray
        print("jsonaArrayFromOrder = \(JSONArray)")
        
        if JSONArray.count != 0 {

            for i:Int in 0 ..< JSONArray.count {

                let jObject = JSONArray[i] as! NSDictionary

                let uOrder:orderDataNewModel = orderDataNewModel()
                uOrder.pname = (jObject["pname"] as AnyObject? as? String) ?? ""
                uOrder.service_type = (jObject["service_type"] as AnyObject? as? String) ?? ""
                uOrder.id = (jObject["id"] as AnyObject? as? String) ?? ""
                uOrder.user_id = (jObject["user_id"] as AnyObject? as? String) ?? ""
                uOrder.order_id = (jObject["order_id"] as AnyObject? as? String) ?? ""
                uOrder.category = (jObject["category"] as AnyObject? as? String) ?? ""
                uOrder.item = (jObject["item"] as AnyObject? as? String) ?? ""
                uOrder.price = (jObject["price"] as AnyObject? as? String) ?? ""
                uOrder.qty = (jObject["qty"] as AnyObject? as? String) ?? ""
                uOrder.last_updated_date = (jObject["last_updated_date"] as AnyObject? as? String) ?? ""
                uOrder.address = (jObject["address"] as AnyObject? as? String) ?? ""
                
                let first = (uOrder.price as NSString).integerValue
                let second = (uOrder.qty as NSString).integerValue
                let multi = first * second
                
                totVar = totVar + multi
                print("TOTR = \(totVar)")
                totQuantity = totQuantity + (uOrder.qty as NSString).integerValue
                
              
                orderData.append(uOrder)
                
            }

           // self.orderDetailTableView.reloadData()
        }
        
        self.orderDetailTableView.reloadData()
       
        updateBottomValues()
    }
    
  
    func updateBottomValues(){
        
//        switch UIScreen.main.nativeBounds.height {
//        case 960:
//            print(".iPhone4_4S")
//            self.totalLabel.text = String(totQuantity) + "        " + totTotal
//        case 1136:
//             print("iPhones_5_5s_5c_SE")
//            self.totalLabel.text = String(totQuantity) + "        " + totTotal
//        case 1334:
//             print("iPhones_6_6s_7_8")
//            self.totalLabel.text = String(totQuantity) + "            " + totTotal
//        case 1920, 2208:
//             self.totalLabel.text = String(totQuantity) + "            " + totTotal
//            print(".iPhones_6Plus_6sPlus_7Plus_8Plus")
//        case 2436:
//             self.totalLabel.text = String(totQuantity) + "            " + totTotal
//             print("iPhoneX")
//        default:
//            print("unknown")
//        }
        
//        if UIScreen.main.nativeBounds.height == 2436 {
//            updatedFrame?.size.height += 50
//            print("IphoneX😇")
//        }else{
//            updatedFrame?.size.height += 20
//            print("SomeOther123")
//        }
    
        self.totalLabel.text = totTotal
        self.discountLabel.text = promoAmt.isEmpty ? "0": promoAmt
        self.surChargeLabel.text = surCharge
        self.grandTotalLabel.text = GrandTot
        self.qtyLabel.text = String(totQuantity)
     
    }
    
    
  

    
    @IBAction func backAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderSummaryTableViewCell", for: indexPath) as! OrderSummaryTableViewCell
        
        let first = (orderData[indexPath.row].price as NSString).integerValue
        let second = (orderData[indexPath.row].qty as NSString).integerValue
        let multi = first * second
        

        cell.serviceType.text = orderData[indexPath.row].service_type
        cell.categoryType.text = orderData[indexPath.row].category
        cell.itemsLabel.text = orderData[indexPath.row].item
        cell.qtyLabel.text = orderData[indexPath.row].qty
        cell.priceLabel.text = String(multi)
        
        return cell
        
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

    
}
