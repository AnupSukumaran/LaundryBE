//
//  PlaceOrderForMenViewController.swift
//  Laundrybe
//
//  Created by Sukumar Anup Sukumaran on 29/11/17.
//  Copyright © 2017 Sukumar Anup Sukumaran. All rights reserved.
//

import UIKit
import NVActivityIndicatorView




class PlaceOrderForMenViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NVActivityIndicatorViewable {
    
    
    
    
    @IBOutlet weak var orderListTabelView: UITableView!
    
    @IBOutlet weak var NoResultView: UIView!
    
    
    let providerApi = APIService()
    var priceDataList = [PriceListModel]()
    var placeOrderSummary = [PlaceOrderModel]()
    var data = [PersistSummary]()
    
    
    @IBOutlet weak var totalPrice: UILabel!
    
//    @IBOutlet weak var backButton: UIBarButtonItem!
    
    
    var idVal = ""
    var proIdVal = ""
    

    
    var newTot = 0
    
    var variValue: Int = 0
    var NewCountValue: [Int] = []
    
    var dataKeys = [String]()
    
    var calledAlready = true

    override func viewDidLoad() {
        super.viewDidLoad()
        
        orderListTabelView.rowHeight = UITableViewAutomaticDimension
        orderListTabelView.estimatedRowHeight = 60
        
        
        self.navigationController?.navigationItem.leftBarButtonItem?.title = "Back"
        

        
        NoResultView.isHidden = true
        
         self.startAnimating(message: "", type: NVActivityIndicatorType.ballSpinFadeLoader, color: .white, padding: 5)
        
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.tintColor = UIColor.white
        let fontDictionary = [ NSAttributedStringKey.foregroundColor:UIColor.white, NSAttributedStringKey.font: UIFont(name: "Arial Rounded MT Bold", size: 18.0)!  ]
        
        self.navigationController?.navigationBar.titleTextAttributes = fontDictionary
        self.navigationController?.navigationBar.setBackgroundImage(imageLayerForGradientBackground(), for: UIBarMetrics.default)
        
        orderListTabelView.delegate = self
        orderListTabelView.dataSource = self
         globalLabel.sharedInstance.proID = proIdVal
        
        print("idVal = \(idVal)")
        providerApi.id = idVal
        print("proIdVal = \(proIdVal)")
        providerApi.proId = proIdVal
        
        callingApi()
        
        globalLabel.sharedInstance.serviceID.append(proIdVal)
        
        if globalLabel.sharedInstance.totvalue == 0{
            UserDefaults.standard.removeObject(forKey: "TotalKeys")
            UserDefaults.standard.removeObject(forKey: idVal)
            UserDefaults.standard.removeObject(forKey: idVal + "W")
            UserDefaults.standard.removeObject(forKey: idVal + "C")
            UserDefaults.standard.removeObject(forKey: idVal + "H")
        }
        
        savingSelections()
        
        passingValuesToWTab()
        passingValuesToCTab()
        passingValuesToHTab()


        globalLabel.sharedInstance.dataKey.append(idVal)
         print("DataKeys = \(globalLabel.sharedInstance.dataKey.map{$0})")

         UserDefaults.standard.set(globalLabel.sharedInstance.dataKey, forKey: "TotalKeys")
        
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
    
    
    func passingValuesToWTab() {
        
        let secondTab = self.tabBarController?.viewControllers![1] as! UINavigationController
        let vc = secondTab.topViewController as! PlaceOrderForWomenViewController
        vc.idVal = idVal
        vc.proIdVal = proIdVal
        vc.placeOrderSummary = placeOrderSummary
    }
    
    func passingValuesToCTab() {
        
        let secondTab = self.tabBarController?.viewControllers![2] as! UINavigationController
        let vc = secondTab.topViewController as! PlaceOrderForChildViewController
        vc.idVal = idVal
        vc.proIdVal = proIdVal
        
    }
    
    func passingValuesToHTab() {
        
        let secondTab = self.tabBarController?.viewControllers![3] as! UINavigationController
        let vc = secondTab.topViewController as! PlaceOrderForHHldViewController
        vc.idVal = idVal
        vc.proIdVal = proIdVal
        
    }
    
   
    
    
    func callingApi() {
        
        providerApi.getPriceListForMen { (result) in
            switch result {
            case .Success(let data):
                if data.isEmpty {
                    self.NoResultView.isHidden = false
                }
                print("PriceDataList = \(data)")
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
        print("jsonaArrayPrice = \(JSONArray)")

        if JSONArray.count != 0 {

            for i:Int in 0 ..< JSONArray.count {

                let jObject = JSONArray[i] as! NSDictionary

                let uData:PriceListModel = PriceListModel()
                uData.id = (jObject["id"] as AnyObject? as? String) ?? ""
                uData.type = (jObject["type"] as AnyObject? as? String) ?? ""
                uData.price = (jObject["price"] as AnyObject? as? String) ?? ""
                uData.provider_name = (jObject["provider_name"] as AnyObject? as? String) ?? ""
                uData.service = (jObject["service"] as AnyObject? as? String) ?? ""
                uData.cloth = (jObject["cloth"] as AnyObject? as? String) ?? ""
                uData.countLabel = 0
                
                
                priceDataList.append(uData)

            }
            

            self.orderListTabelView.reloadData()
        }
    }
    
    func savingSelections() {
        if let NewCount = UserDefaults.standard.array(forKey:  providerApi.id) as? [Int] {
            
            globalLabel.sharedInstance.dataKey.append(providerApi.id)
            
            NewCountValue = NewCount
            print("Values = \(NewCountValue)")
        }else{
            print("Empty")
        }
        
    }
    
    
 
    
    override func viewWillAppear(_ animated: Bool) {
        totalPrice.text = String(globalLabel.sharedInstance.totvalue)
        newTot = globalLabel.sharedInstance.totvalue
         print("GogbalvalueM = \(globalLabel.sharedInstance.totvalue)")
        
        if priceDataList.isEmpty {
              print("HasLoaded")
            callingApi()
        }
    }
    
    
//    @IBAction func backAction(_ sender: UIBarButtonItem) {
//
//        dismiss(animated: true, completion: nil)
//
//    }
    @IBAction func backAction(_ sender: UIButton) {
         dismiss(animated: true, completion: nil)
    }
    
    
    func savingSelectData() {
        

        var data = [Int]()
        
        if NewCountValue.isEmpty {
            data = priceDataList.map {$0.countLabel}
        }else{
            data =  NewCountValue.map{$0}
        }
        
        print("Data = \(data)")
        
        UserDefaults.standard.set(data, forKey:  idVal)

    }
    
    

  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return priceDataList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {


        let cell = tableView.dequeueReusableCell(withIdentifier: "orderListTableViewCell", for: indexPath) as! orderListTableViewCell
        
        cell.genderImage.image = UIImage(named: "vectorMen")

        cell.addbutton.tag = indexPath.row
        cell.MinusButton.tag = indexPath.row

        
        if NewCountValue.isEmpty {
             cell.countLabel.text = String(priceDataList[indexPath.row].countLabel)
        }else{
            cell.countLabel.text = String(NewCountValue[indexPath.row])
        }
        
    
        cell.priceLabel.text = "₹ " + priceDataList[indexPath.row].price

        cell.productType.text = priceDataList[indexPath.row].cloth

        cell.addbutton.addTarget(self, action: #selector(addFunc(_:)), for: .touchUpInside)

        cell.MinusButton.addTarget(self, action: #selector(minusFunc(_:)), for: .touchUpInside)

        return cell

    }

 

    @objc func addFunc(_ sender: UIButton){


        newTot = newTot + Int(priceDataList[sender.tag].price)!

        if NewCountValue.isEmpty {
            variValue = priceDataList[sender.tag].countLabel
        }else{
            variValue = NewCountValue[sender.tag]
        }
    
        variValue += 1

        totalPrice.text = String(newTot)

        globalLabel.sharedInstance.totvalue = newTot

        if NewCountValue.isEmpty {
            priceDataList[sender.tag].countLabel = variValue
           
        }else{
            NewCountValue[sender.tag] = variValue
            
        }
        
        savingSelectData()
    
        orderListTabelView.reloadData()


    }



   @objc func minusFunc(_ sender: UIButton) {


    
    
    if NewCountValue.isEmpty {
        variValue = priceDataList[sender.tag].countLabel
    }else{
        variValue = NewCountValue[sender.tag]
    }

    if variValue > 0 {

        newTot = newTot - Int(priceDataList[sender.tag].price)!

        variValue -= 1

    }else{
        print("Reached limit")
    }

    totalPrice.text = String(newTot)
     globalLabel.sharedInstance.totvalue = newTot

    if NewCountValue.isEmpty {
        priceDataList[sender.tag].countLabel = variValue
    }else{
        NewCountValue[sender.tag] = variValue
    }

    savingSelectData()
    orderListTabelView.reloadData()


    }
    
    
    @IBAction func sendTotalAction(_ sender: Any) {
        
        calledAlready  = false
        print("Works")
        
        if newTot < 200 && newTot != 0{
            
            let alert = UIAlertController(title: "Additional Charge", message: "Rs.50 for Order Below 200", preferredStyle: .alert)
            
            let confirmAction = UIAlertAction(title: "Confirm", style: .default){
                
                [unowned self] action in
                
               
                 //   self.sendTotalDataInfo()
                 globalLabel.sharedInstance.placeOrderCombined.append(contentsOf: self.placeOrderSummary)
                self.sendTotalDataInfo()
                self.orderSummaryVC()
               
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .default)
            
            alert.addAction(confirmAction)
            alert.addAction(cancelAction)
            
            present(alert, animated: true, completion: nil)
            
        }else if newTot == 0 {
            let alert = UIAlertController(title: "Alert!", message: "Please select items", preferredStyle: UIAlertControllerStyle.alert)
            
            
            self.present(alert, animated: true, completion: nil)
            let delay = 2.0 * Double(NSEC_PER_SEC)
            let time = DispatchTime.now() + Double(Int64(delay)) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: time, execute: {
                
                alert.dismiss(animated: true, completion: nil)
            })
        } else {
            
            
             sendTotalDataInfo()
            self.orderSummaryVC()
            
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        print("CalledAlready = \(calledAlready)")
        if calledAlready {
             print("viewWillDisappear")
         sendTotalDataInfo()
             globalLabel.sharedInstance.placeOrderCombined.append(contentsOf: placeOrderSummary)
        }
        
       
    }
    
//    var filePath: String {
//        let serviceType = proIdVal
//        print("SERVICE = \(serviceType)")
//        let manager = FileManager.default
//        let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first
//        return url!.appendingPathComponent(serviceType).path
//    }
//
//
//
//    private func saveData(persistSummary: PersistSummary) {
//
//        data.append(persistSummary)
//        print("dataPLace = \(data.map{$0.Item})")
//        NSKeyedArchiver.archiveRootObject(data, toFile: filePath)
//    }
//
//
//
//
//    func deleteFileManager() {
//
//        data.removeAll()
//         NSKeyedArchiver.archiveRootObject(data, toFile: filePath)
//
//
//    }
    
    func sendTotalDataInfo() {
       
      
        
       
        placeOrderSummary.removeAll()
        
      
        let nonCat = globalLabel.sharedInstance.placeOrderCombined.filter{ $0.filterCode != idVal + "men"}
       // nonCat = globalLabel.sharedInstance.placeOrderCombined.filter{ $0.serviceType != servType }
        globalLabel.sharedInstance.placeOrderCombined.removeAll()
        globalLabel.sharedInstance.placeOrderCombined.append(contentsOf: nonCat)
        
        globalLabel.sharedInstance.placeOrderSummary.removeAll()
        
        for i:Int in 0 ..< priceDataList.count {
            
            let auxPlaceOrder: PlaceOrderModel = PlaceOrderModel()
            
            if NewCountValue.isEmpty{
            
            if Int(priceDataList[i].countLabel) > 0 {
            
                auxPlaceOrder.item = priceDataList[i].cloth
                auxPlaceOrder.price = priceDataList[i].price
                auxPlaceOrder.category = priceDataList[i].type
                auxPlaceOrder.quantity = NSNumber.init(value: priceDataList[i].countLabel).stringValue
                auxPlaceOrder.serviceType = priceDataList[i].service
                auxPlaceOrder.filterCode = idVal + "men"
                
                placeOrderSummary.append(auxPlaceOrder)
                
              
                globalLabel.sharedInstance.placeOrderSummary.append(auxPlaceOrder)
                
 
            }
                
        }else{
            
            if Int(NewCountValue[i]) > 0 {
                
                auxPlaceOrder.item = priceDataList[i].cloth
                auxPlaceOrder.price = priceDataList[i].price
                auxPlaceOrder.category = priceDataList[i].type
                auxPlaceOrder.quantity = NSNumber.init(value: NewCountValue[i]).stringValue
                auxPlaceOrder.serviceType = priceDataList[i].service
                auxPlaceOrder.filterCode = idVal + "men"
                
                placeOrderSummary.append(auxPlaceOrder)
                
                globalLabel.sharedInstance.placeOrderSummary.append(auxPlaceOrder)
                

            }

        }
      
     }
        
   
    }
    
  
    
    func orderSummaryVC() {
      
        globalLabel.sharedInstance.placeOrderCombined.append(contentsOf: self.placeOrderSummary)
        let orderSummary = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OrderSummaryViewController") as! OrderSummaryViewController
        
      
        let navController = UINavigationController(rootViewController: orderSummary)
        
        self.present(navController, animated: true, completion: nil)
        
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


