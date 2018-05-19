//
//  MyOrdersListViewController.swift
//  Laundrybe
//
//  Created by Sukumar Anup Sukumaran on 20/12/17.
//  Copyright © 2017 Sukumar Anup Sukumaran. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class MyOrdersListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NVActivityIndicatorViewable {
    
    
    
    @IBOutlet weak var orderListTable: UITableView!
    
    var myOrder = [MyOrderModelData]()
    var providerApi = APIService()
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.tintColor = UIColor.white
        let fontDictionary = [ NSAttributedStringKey.foregroundColor:UIColor.white, NSAttributedStringKey.font: UIFont(name: "Arial Rounded MT Bold", size: 18.0)!  ]
        
        self.navigationController?.navigationBar.titleTextAttributes = fontDictionary
        self.navigationController?.navigationBar.setBackgroundImage(imageLayerForGradientBackground(), for: UIBarMetrics.default)
        
        callingUrl()

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
        providerApi.myorderDetails { (values) in
            
            switch values {
            case .Success(let data):
                if data.count == 1{
                    print("emptyDa")
                }
                print("OrderId  = \(data)")
                self.jsonResultParse(data as AnyObject)
                self.stopAnimating()
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
                
                let uOrder:MyOrderModelData = MyOrderModelData()
                uOrder.order_id = (jObject["order_id"] as AnyObject? as? String) ?? ""
                uOrder.pick_date = (jObject["pick_date"] as AnyObject? as? String) ?? ""
                uOrder.pick_time = (jObject["pick_time"] as AnyObject? as? String) ?? ""
                uOrder.delivery_date = (jObject["delivery_date"] as AnyObject? as? String) ?? ""
                uOrder.total_price = (jObject["total_price"] as AnyObject? as? String) ?? ""
                uOrder.sur_charges = (jObject["sur_charges"] as AnyObject? as? String) ?? ""
                uOrder.address = (jObject["address"] as AnyObject? as? String) ?? ""
                uOrder.payment_mode = (jObject["payment_mode"] as AnyObject? as? String) ?? ""
                uOrder.area = (jObject["area"] as AnyObject? as? String) ?? ""
                uOrder.promo_amount = (jObject["promo_amount"] as AnyObject? as? String) ?? ""
                uOrder.cloth_status = (jObject["cloth_status"] as AnyObject? as? String) ?? ""
                uOrder.order_data = (jObject["order_data"] as AnyObject? as? String) ?? ""
                myOrder.append(uOrder)
                
            }
           
            self.orderListTable.reloadData()
        }
      
        
    }
    
    @IBAction func MenuAction(_ sender: UIBarButtonItem) {
        if let container = self.so_containerViewController {
            container.isSideViewControllerPresented = true
        }
    }
    
//    @IBAction func menuButtonAction(_ sender: Any) {
//        if let container = self.so_containerViewController {
//            container.isSideViewControllerPresented = true
//        }
//    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myOrder.count
    }
    
    var IncludeSurC = 0
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderTableViewCell", for: indexPath) as! OrderTableViewCell
        
       
//        if (myOrder[indexPath.row].promo_amount as NSString).integerValue == 0 {
//
//              IncludeSurC = (myOrder[indexPath.row].total_price as NSString).integerValue + (myOrder[indexPath.row].sur_charges as NSString).integerValue
//
//        }else{
//
//              IncludeSurC = (myOrder[indexPath.row].promo_amount as NSString).integerValue + (myOrder[indexPath.row].sur_charges as NSString).integerValue
//
//        }
        
        
        IncludeSurC = (myOrder[indexPath.row].total_price as NSString).integerValue - (myOrder[indexPath.row].promo_amount as NSString).integerValue + (myOrder[indexPath.row].sur_charges as NSString).integerValue
        
        //print("PromoamountWatch = \((myOrder[indexPath.row].promo_amount as NSString).integerValue)")
        
        cell.orderStatusLabel.text = myOrder[indexPath.row].cloth_status
        cell.OrderIdLabel.text =  myOrder[indexPath.row].order_id
        cell.pickDateLabel.text =  myOrder[indexPath.row].pick_date
        cell.pickTimeLabel.text =  myOrder[indexPath.row].pick_time
        cell.areaLabel.text =  myOrder[indexPath.row].area
        cell.paymentLabel.text =  myOrder[indexPath.row].payment_mode
        cell.totalAmt.text =  String(IncludeSurC)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OrderDetailsViewController") as! OrderDetailsViewController
        
        vc.orderID = myOrder[indexPath.row].order_id
        vc.surCharge = myOrder[indexPath.row].sur_charges
        
        print("PROMOAMT = \(myOrder[indexPath.row].promo_amount )")
        print("GrandTot = \(myOrder[indexPath.row].total_price)")
         print("SurCharge = \(myOrder[indexPath.row].sur_charges)")
        
      let IncludeSurC = (myOrder[indexPath.row].total_price as NSString).integerValue - (myOrder[indexPath.row].promo_amount as NSString).integerValue + (myOrder[indexPath.row].sur_charges as NSString).integerValue
        
        vc.totTotal = myOrder[indexPath.row].total_price
        vc.GrandTot = String(IncludeSurC)
//        if myOrder[indexPath.row].promo_amount.isEmpty{
//            vc.GrandTot = myOrder[indexPath.row].total_price
//        }else{
//            vc.GrandTot = myOrder[indexPath.row].promo_amount
//        }
        
        vc.promoAmt = myOrder[indexPath.row].promo_amount

        
        let navController = UINavigationController(rootViewController: vc)
        present(navController, animated: true, completion: nil)
        
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
