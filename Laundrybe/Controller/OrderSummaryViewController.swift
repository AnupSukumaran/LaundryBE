//
//  orderSummaryViewController.swift
//  Laundrybe
//
//  Created by Sukumar Anup Sukumaran on 01/12/17.
//  Copyright © 2017 Sukumar Anup Sukumaran. All rights reserved.
//

import UIKit





class OrderSummaryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var summaryTabelView: UITableView!
    
    @IBOutlet weak var TotalLabel: UILabel!
    @IBOutlet weak var totalQuantity: UILabel!
    @IBOutlet weak var surChargeLabel: UILabel!
    @IBOutlet weak var grandTotalLabel: UILabel!
    
    
    var sameData = [PlaceOrderModel]()
    
    
     var placeOrderSummary = [PlaceOrderModel]()
    var placeOrderSummaryW = [PlaceOrderModel]()
    var Transfer = [ToSendModel]()
    
    //var arrayData = [PlaceOrderModel]()
   
    var newCombined = [PersistSummary]()
   var newData = [PersistSummary]()
    
    var proId = ""
    var totVar = 0
    var totQuantity = 0
    var jsonString = ""
    
    
    //@IBOutlet weak var backButtonItem: UIBarButtonItem!
    @IBOutlet weak var totalLabelLength: NSLayoutConstraint!
    

    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.tintColor = UIColor.white
        let fontDictionary = [ NSAttributedStringKey.foregroundColor:UIColor.white, NSAttributedStringKey.font: UIFont(name: "Arial Rounded MT Bold", size: 18.0)!  ]
        
        self.navigationController?.navigationBar.titleTextAttributes = fontDictionary
        self.navigationController?.navigationBar.setBackgroundImage(imageLayerForGradientBackground(), for: UIBarMetrics.default)
        
        

        placeOrderSummary = globalLabel.sharedInstance.placeOrderSummary
        let Men = placeOrderSummary.map{$0.item}
        print("MENData = \(Men)")
        
        placeOrderSummaryW = globalLabel.sharedInstance.placeOrderSummaryW
        let Women = placeOrderSummaryW.map{$0.item}
        print("WomenData = \(Women)")
        
        sameData = globalLabel.sharedInstance.placeOrderCombined

        
        print("Combined = \(sameData.map{$0.item})")
       
        toTransferData()
  
//        let button = UIButton(type: .system)
//        button.setImage(UIImage(named: "whiteArrow"), for: .normal)
//        button.setTitle("YourTitle", for: .normal)
//        button.sizeToFit()
//        backButtonItem.image = UIImage(named: "whiteArrow")
//        backButtonItem.title = "UIBarButtonItem(customView: button)"
        
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "whiteArrow"), for: .normal)
        button.setTitle("YourTitle", for: .normal)
        button.sizeToFit()
        self.navigationController?.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
        
        if UIScreen.main.nativeBounds.height == 2732{
            totalLabelLength.constant = 575
        }else if  UIScreen.main.nativeBounds.height == 2224 {
            totalLabelLength.constant = 479
        }
      
    }
    
    func checkReachability(){
        if currentReachabilityStatus == .reachableViaWiFi {
            
            print("User is connected to the internet via wifi.")
            
        }else if currentReachabilityStatus == .reachableViaWWAN{
            
            print("User is connected to the internet via WWAN.")
            
        } else {
           // self.stopAnimating()
            
            let alert = UIAlertController(title: "No Internet Connection", message: "Make sure your device is connected to the internet", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }
    }
    
   
    
    override func viewDidLayoutSubviews() {
        checkReachability()
        
        TotalLabel.text = String(totVar)
        totalQuantity.text = String(totQuantity)
        if totVar < 200 {
            surChargeLabel.text = "50"
            grandTotalLabel.text = String(totVar + 50)
        }else{
            surChargeLabel.text = "0"
            grandTotalLabel.text = "\(totVar)"
        }
        
       
        
    }
    
    
    func toTransferData() {
        
        if sameData.count != 0 {
            
            for i:Int in 0 ..< sameData.count {
                
                let transferData: ToSendModel = ToSendModel()
                
                transferData.category = sameData[i].category
                transferData.item = sameData[i].item
                transferData.pname = globalLabel.sharedInstance.pname
                transferData.price = sameData[i].price
                transferData.qty = sameData[i].quantity
                transferData.service_type = sameData[i].serviceType
                
                Transfer.append(transferData)
                
            }
            
            let jsonEncoder = JSONEncoder()
            do {
                let jsonData = try jsonEncoder.encode(Transfer)
                jsonString = String(data: jsonData, encoding: .utf8)!
                print("JSON String : " + jsonString)
            }
            catch let error{
                print("Error = \(error.localizedDescription)")
            }
        }
    }
    
    
    
    
    func adjustTheTableHeight(){
    
        var frame: CGRect = self.summaryTabelView.frame
        frame.size.height = self.summaryTabelView.contentSize.height
       // self.tableViewHeight.constant = self.summaryTabelView.contentSize.height
        self.summaryTabelView.frame = frame
        
        print("TableHeight2 = \(self.summaryTabelView.contentSize.height)")
        summaryTabelView.reloadData()
    }
    
    
//    @IBAction func BackAction(_ sender: UIBarButtonItem) {
//        dismiss(animated: true, completion: nil)
//    }
    
    @IBAction func backAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 2
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
//        if section == 0 {
//            return 1
//        }else if section == 1 {
            return sameData.count
//        }else{
//            return 0
//        }
        //return sameData.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        if indexPath.section == 0 {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderSummaryTableViewCell", for: indexPath) as! OrderSummaryTableViewCell
//            return cell
//
//
//        }else if indexPath.section == 1{
//
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderSummaryTableViewCell", for: indexPath) as! OrderSummaryTableViewCell
        
        let first = (sameData[indexPath.row].price as NSString).integerValue
        let second = (sameData[indexPath.row].quantity as NSString).integerValue
        let multi = first * second
        totVar = totVar + multi
        totQuantity = totQuantity + (sameData[indexPath.row].quantity as NSString).integerValue
        
        cell.serviceType.text = sameData[indexPath.row].serviceType
        cell.categoryType.text = sameData[indexPath.row].category
        cell.itemsLabel.text = sameData[indexPath.row].item
        cell.priceLabel.text = String(multi)
        cell.qtyLabel.text = sameData[indexPath.row].quantity
        
        return cell
//        }else{
//
//            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderSummaryTableViewCell", for: indexPath) as! OrderSummaryTableViewCell
//            return cell
//
//        }
    }

    @IBAction func OrderNowAction(_ sender: UIButton) {
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ScheduleTableViewController") as! ScheduleTableViewController
        
        vc.sur_charges = surChargeLabel.text!
        vc.totalPrice = String(totVar)
        vc.orderCloth = jsonString
        
        let navController = UINavigationController(rootViewController:vc)
        
        present(navController, animated: true, completion: nil)
        
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
