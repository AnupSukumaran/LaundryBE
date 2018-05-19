//
//  ScheduleTableViewController.swift
//  Laundrybe
//
//  Created by Sukumar Anup Sukumaran on 01/12/17.
//  Copyright © 2017 Sukumar Anup Sukumaran. All rights reserved.
//

import UIKit
import GooglePlacePicker
import CoreLocation
import NVActivityIndicatorView


class ScheduleTableViewController: UITableViewController, DatePopUpControllerDelegate, TimePopUpControllerDelegate,OrderPopUpControllerDelegate, CLLocationManagerDelegate, NVActivityIndicatorViewable {
    
    
    
    
    @IBOutlet weak var locationView: CustomView!
    
    @IBOutlet weak var labelScroll: UIScrollView!
    
    @IBOutlet var detailTableView: UITableView!
    
    @IBOutlet weak var checkWork: UIButton!
    @IBOutlet weak var checkHome: UIButton!
    @IBOutlet weak var checkOther: UIButton!
    
    @IBOutlet weak var locationAddress: UILabel!
    @IBOutlet weak var locationPicker: UIButton!
    @IBOutlet weak var pickedDate: UILabel!
    @IBOutlet weak var pickTime: UILabel!
    
    @IBOutlet weak var promoCodeTextField: UITextField!
    @IBOutlet weak var codPayment: UIButton!
    
    @IBOutlet weak var cardPayment: UIButton!
    
    @IBOutlet weak var paytmButton: UIButton!
    
     var activeField: UITextField?
    
    var currentLocation = CLLocation()
    let locationManager = CLLocationManager()
    
    var userName = ""
    var email = ""
    var mobile = ""
    
    var providerApi = APIService()
    
    
    var paymode = ""
    var area = ""
    var mylocation: locationMode = locationMode()
    
     var SelectedPlaceInfo = [String]()
    var sur_charges = ""
    var totalPrice = ""
    var orderCloth = ""
   
   
    //backButtonOutlet
    @IBOutlet weak var backButtonOutlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.tintColor = UIColor.white
        let fontDictionary = [ NSAttributedStringKey.foregroundColor:UIColor.white, NSAttributedStringKey.font: UIFont(name: "Arial Rounded MT Bold", size: 18.0)!  ]
        
        self.navigationController?.navigationBar.titleTextAttributes = fontDictionary
        self.navigationController?.navigationBar.setBackgroundImage(imageLayerForGradientBackground(), for: UIBarMetrics.default)
        
       
        tableView.isScrollEnabled = true
        
        checkWork.setBackgroundImage(UIImage(named:"Box"), for: .normal)
        checkWork.setBackgroundImage(UIImage(named:"check"), for: .selected)
        
        checkHome.setBackgroundImage(UIImage(named:"Box"), for: .normal)
        checkHome.setBackgroundImage(UIImage(named:"check"), for: .selected)

        checkOther.setBackgroundImage(UIImage(named:"Box"), for: .normal)
        checkOther.setBackgroundImage(UIImage(named:"check"), for: .selected)
        
        
      
        registerForKeyboardNotifications()
        
       
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
 
//       print("Table = \(detailTableView.rowHeight)")
        
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
    
    
    
    
    
    @objc func dismissKeyboard() {
        
        promoCodeTextField.resignFirstResponder()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        
        
    }
    
   
    @IBAction func codPaymet(_ sender: UIButton) {
        codPayment.backgroundColor = #colorLiteral(red: 1, green: 0.4660309014, blue: 0.2239294546, alpha: 1)
        paymode = "COD"
    }
    
    @IBAction func cardPaymentAction(_ sender: Any) {
        
        let alert = UIAlertController(title: "Comming Soon", message: "Under development", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func paytmAction(_ sender: Any) {
        
        let alert = UIAlertController(title: "Comming Soon", message: "Under development", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
        
    }
    

   
    @IBAction func checkWorkAction(_ sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
        area = "Work"
        checkHome.isSelected = false
        checkOther.isSelected = false
    }
    
    @IBAction func checkHomeAction(_ sender: UIButton) {
        
        area = "Home"
        sender.isSelected = !sender.isSelected
        checkWork.isSelected = false
        checkOther.isSelected = false
        
    }
    
    @IBAction func checkOtherAction(_ sender: UIButton) {
        
        area = "Other"
         sender.isSelected = !sender.isSelected
        checkWork.isSelected = false
        checkHome.isSelected = false
    }
    
    
    @IBAction func pickDate(_ sender: Any) {
        
        let popOverVc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PopUpForDateViewController") as! PopUpForDateViewController
        
        self.addChildViewController(popOverVc)
        self.view.addSubview(popOverVc.view)
        
        //MARK: Centering the popup view
        popOverVc.view.center = CGPoint(x: self.view.bounds.midX , y: self.view.bounds.midY)
        popOverVc.didMove(toParentViewController: self)
        tableView.isScrollEnabled = false
        backButtonOutlet.isEnabled = false
        
         self.navigationController?.navigationBar.barTintColor = UIColor.black.withAlphaComponent(0.0)
        popOverVc.delegate = self
       
    }
    
    
    @IBAction func pickTime(_ sender: Any) {
        
        let popOverVc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TimePopUpViewController") as! TimePopUpViewController
        
        self.addChildViewController(popOverVc)
        self.view.addSubview(popOverVc.view)
        
        //MARK: Centering the popup view
        popOverVc.view.center = CGPoint(x: self.view.bounds.midX , y: self.view.bounds.midY)
        popOverVc.didMove(toParentViewController: self)
        tableView.isScrollEnabled = false
        backButtonOutlet.isEnabled = false
        self.navigationController?.navigationBar.barTintColor = UIColor.black.withAlphaComponent(0.0)
        popOverVc.delegate = self
        
        
    }
    
    
   
    
    @IBAction func backAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func enableScroll() {
        backButtonOutlet.isEnabled = true
        tableView.isScrollEnabled = true
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.7803230882, green: 0.780436337, blue: 0.7802982926, alpha: 1)
    }
    
    func pickedDate(Date: String) {
        pickedDate.text = Date
        pickedDate.textColor = UIColor.black
        backButtonOutlet.isEnabled = true
    }
    
    func enableScrollFromTime() {
        backButtonOutlet.isEnabled = true
        tableView.isScrollEnabled = true
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.7803230882, green: 0.780436337, blue: 0.7802982926, alpha: 1)
    }
    
    func pickedTime(Time: String) {
        pickTime.text = Time
        pickTime.textColor = UIColor.black
         backButtonOutlet.isEnabled = true
    }
    
    func enableUnwind() {
        backButtonOutlet.isEnabled = true
        print("DelegateWORKS")
        self.performSegue(withIdentifier: "unwindToMenu", sender: self)
    }
    
    
    //MARK: LOCATION FUNCTION
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        CLGeocoder().reverseGeocodeLocation(manager.location!, completionHandler: {(placemarks, error)->Void in
            
            if (error != nil) {
                print("Reverse geocoder failed with error" + (error?.localizedDescription)!)
                return
            }
            
            if (placemarks?.count)! > 0 {
                let pm = placemarks?[0]
                self.displayLocationInfo(pm)
            } else {
                print("Problem with the data received from geocoder")
            }
        })
    }
    
    func displayLocationInfo(_ placemark: CLPlacemark?) {
        if CLLocationManager.authorizationStatus() == .denied{
            
            let alertControllerz = UIAlertController(title: "Laundrybe", message: "This application requires location services to work. Do you want to enable location from settings?", preferredStyle: UIAlertControllerStyle.alert)
            
            alertControllerz.addAction(UIAlertAction(title: "YES", style: .default, handler: { (action: UIAlertAction!) in
                
//                UIApplication.shared.openURL(NSURL(string: UIApplicationOpenSettingsURLString)! as URL)
                
                //openURL:options:completionHandler: instead
                
                if #available(iOS 10.0, *) {
                    print("IOS 10.0 or above")
                    UIApplication.shared.open(NSURL(string: UIApplicationOpenSettingsURLString)! as URL, options: [:], completionHandler: nil)
                } else {
                    print("IOS below 10.0 ")
                    UIApplication.shared.openURL(NSURL(string: UIApplicationOpenSettingsURLString)! as URL)
                    // Fallback on earlier versions
                }
            }))
            
            alertControllerz.addAction(UIAlertAction(title: "NO", style: .default, handler: { (action: UIAlertAction!) in
            }))
            
            self.present(alertControllerz, animated: true, completion: nil)
        }else{
            
            
            if placemark != nil {
                
                if let currLoc = locationManager.location{
                    currentLocation = currLoc
                    
                    mylocation.latitude = "\(currentLocation.coordinate.latitude)"
                    
                    mylocation.longitude = "\(currentLocation.coordinate.longitude)"
           
                }
 
            }
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error while updating location " + error.localizedDescription)
    }
    
    
    
    @IBAction func locationPickerAction(_ sender: Any) {
        
        if CLLocationManager.authorizationStatus() == .denied{
            
            let alertControllerz = UIAlertController(title: "Laundrybe", message: "This application requires location services to work. Do you want to enable location from settings?", preferredStyle: UIAlertControllerStyle.alert)
            
            alertControllerz.addAction(UIAlertAction(title: "YES", style: .default, handler: { (action: UIAlertAction!) in
                
                UIApplication.shared.openURL(NSURL(string: UIApplicationOpenSettingsURLString)! as URL)
                
                
                
                
            }))
            
            alertControllerz.addAction(UIAlertAction(title: "NO", style: .default, handler: { (action: UIAlertAction!) in
            }))
            
            self.present(alertControllerz, animated: true, completion: nil)
            
        }else{
            
            
            if mylocation.latitude.isEmpty && mylocation.latitude.isEmpty {
                locationManager.startUpdatingLocation()
                
                let alert = UIAlertView(title: "Laundrybe", message: "Location not found!!.Please try again", delegate: nil, cancelButtonTitle: "OK")
                alert.show()
            }else{
                
                let center = CLLocationCoordinate2D(latitude: Double(mylocation.latitude)!, longitude: Double(mylocation.longitude)!)
                let northEast = CLLocationCoordinate2D(latitude: center.latitude + 0.001, longitude: center.longitude + 0.001)
                let southWest = CLLocationCoordinate2D(latitude: center.latitude - 0.001, longitude: center.longitude - 0.001)
                let viewport = GMSCoordinateBounds(coordinate: northEast, coordinate: southWest)
                let config = GMSPlacePickerConfig(viewport: viewport)
                
                
                let placePicker = GMSPlacePickerViewController(config: config)
                
                placePicker.delegate = self //as! GMSPlacePickerViewControllerDelegate
                placePicker.modalPresentationStyle = .popover
                placePicker.popoverPresentationController?.sourceView = locationPicker
                placePicker.popoverPresentationController?.sourceRect = locationPicker.bounds
                
                present(placePicker, animated: true, completion: nil)
                
                
            }
        }
        
        
    }
    
    deinit {
        deregisterFromKeyboardNotifications()
    }
    
    
    func registerForKeyboardNotifications()
    {
        print("Working")
        //Adding notifies on keyboard appearing
        NotificationCenter.default.addObserver(self, selector: #selector(SignUpViewController.keyboardWasShown(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(SignUpViewController.keyboardWillBeHidden(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    
    func deregisterFromKeyboardNotifications()
    {
        //Removing notifies on keyboard appearing
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    
    @objc func keyboardWasShown(notification: NSNotification)
    {
        
        let info : NSDictionary = notification.userInfo! as NSDictionary
        let keyboardSize = (info[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize!.height + 14, 0.0)
        

        print("CONTE = \(detailTableView.contentInset)")
        print("CONTEScroll = \(detailTableView.scrollIndicatorInsets)")
        detailTableView.contentInset = contentInsets
        detailTableView.scrollIndicatorInsets = contentInsets
        
        
        var aRect : CGRect = self.view.frame

        
        aRect.size.height -= keyboardSize!.height
        

        
        
        if activeField != nil
        {
         
            if (!aRect.contains(activeField!.frame.origin))
            {
                detailTableView.scrollRectToVisible(activeField!.frame, animated: true)
                
                
            }
        }
        
        
    }
    
    @objc func keyboardWillBeHidden(notification: NSNotification)
    {
        detailTableView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        detailTableView.scrollIndicatorInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        self.view.endEditing(true)
 
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        print("Beginging")
        activeField = textField
    }
    
    
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        print("EndEditing")
        activeField = nil
        
    }
    
    @IBAction func orderNowAction(_ sender: Any) {
        

        if (pickedDate.text == "Choose Date") {
            print("DateEmpty")
            let alert = UIAlertController(title: "Message!", message: "Please pick a date", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            
        }else if (pickTime.text == "Choose Time"){
            print("TimeEmpty")
            let alert = UIAlertController(title: "Message!", message: "Please pick a time", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)

        }else if(locationAddress.text == "Pick Address"){
             print("PickAddress")
            let alert = UIAlertController(title: "Message!", message: "Please pick your address", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            
        }else if (checkWork.isSelected == false && checkHome.isSelected == false && checkOther.isSelected == false) {
            
            let alert = UIAlertController(title: "Message!", message: "Please pick an area", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            
        }else if paymode.isEmpty{
            
            let alert = UIAlertController(title: "Message!", message: "Please select a payment method", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            
        }else{
            
            self.startAnimating(message: "", type: NVActivityIndicatorType.ballSpinFadeLoader, color: .white, padding: 5)
            
            if (promoCodeTextField.text?.isEmpty)! {
               
                print("empty")
                orderFunc(promoco: "nil")
            }else{
                providerApi.promoField = promoCodeTextField.text!
                print("Not empty")
                callingUrlForPromo()
                
            }
            
            
        }
    }
    
    func callingUrlForPromo() {
        
        
        
        providerApi.checkPromo { (values) in
            
            switch values {
            case .Success(let data):
                
                
                print("Data232 = \(data) ")
                if data == "true"{
                
                    
                    let alert = UIAlertController(title: "Message!", message: "Promocode not valid", preferredStyle: UIAlertControllerStyle.alert)
                    
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: {
                        
                        self.stopAnimating()
                        
                    })
                    
                }else{
                    
                    let alert = UIAlertController(title: "Message!", message: "Promocode is valid", preferredStyle: UIAlertControllerStyle.alert)
                    
               
                    self.present(alert, animated: true, completion: nil)
                    let delay = 2.0 * Double(NSEC_PER_SEC)
                    let time = DispatchTime.now() + Double(Int64(delay)) / Double(NSEC_PER_SEC)
                    DispatchQueue.main.asyncAfter(deadline: time, execute: {
                        
                        alert.dismiss(animated: true, completion: {
                            
                             self.orderFunc(promoco: self.providerApi.promoField)
                        })
                    })
                    
                   
                    
                }
                
            case .Error(let message):
                
                print("Error = \(message)")
                self.stopAnimating()
            }
            
            
            
        }
    }
    
    func orderFunc(promoco:String){
        
        if let userName2 = UserDefaults.standard.object(forKey: "UserName") as? String {
            userName = userName2
        }
        
        if let email2 = UserDefaults.standard.object(forKey: "EmailKey") as? String {
            
            email = email2
            
        }
        
        
        if let mobile2 = UserDefaults.standard.object(forKey: "MobileKey") as? String {
            
            mobile = mobile2
            
        }
        
        let promocode = promoco
        var promoAmount = promoco.westernArabicNumeralsOnly
        if !promoAmount.isEmpty{
            let proAm:Double = Double((promoAmount as NSString).integerValue)
            print("PromoCo = \(proAm)")
            let tot:Double = Double((totalPrice as NSString).integerValue)
            print("TOT = \(tot)")
            var discountAmount = tot * (proAm/100)
            discountAmount = tot - discountAmount
            print("Discount = \(discountAmount)")
            promoAmount = String(discountAmount)
        }
       
        let providerName = globalLabel.sharedInstance.pname
        
        print("Area = \(area), payment = \(paymode), promocode = \(promocode), provider = \(providerName), surCharge = \(sur_charges), totalPrice = \(totalPrice), orderColths = \(orderCloth)")
        
        providerApi.getOrderParams(user_name: userName, user_email_id: email, user_mobile: mobile, provider_name: providerName, pick_date: pickedDate.text!, pick_time: pickTime.text! , promo_code: promocode, promo_amount: promoAmount, address: locationAddress.text!, sur_charges: sur_charges, payment_mode: paymode, area: area, total_price: totalPrice, order_cloths: String(orderCloth))
        
        callingUrl()
        
        
        
    }
    
    func callingUrl() {
        
        
        
        providerApi.sendDatatoDataB { (values) in
            
            switch values {
            case .Success(let data):
                self.stopAnimating()
                print("OrderId  = \(data)")
                self.jsonResultParse(data as AnyObject)
            case .Error(let message):
                self.stopAnimating()
                 self.alertFunc(message: "Some error occured! Please Try Again")
                print("Error = \(message)")
            }
            
            
            
        }
    }
    
    func alertFunc(message: String) {
        let alert = UIAlertController(title: "Message", message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
        
    }
    
    func jsonResultParse(_ json:AnyObject) {
        
        print("JSONArr = \(json)")
        
        let popOverVc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OrderSuccessPopViewController") as! OrderSuccessPopViewController
        
        self.addChildViewController(popOverVc)
        self.view.addSubview(popOverVc.view)
        
        backButtonOutlet.isEnabled = false
        //MARK: Centering the popup view
        popOverVc.view.center = CGPoint(x: self.view.bounds.midX , y: self.view.bounds.midY)
        popOverVc.didMove(toParentViewController: self)
        tableView.isScrollEnabled = false
        self.navigationController?.navigationBar.barTintColor = UIColor.black.withAlphaComponent(0.0)
       popOverVc.delegate = self
        popOverVc.orderId = json as! String
        
        
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
    
    
    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//    }
    
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 0 {
            if UIScreen.main.nativeBounds.height == 2732{
              return 250
            }else if UIScreen.main.nativeBounds.height == 2048  {
                return 200
            }else{
            return 116
            }
            
        }else if indexPath.row == 1 {
            
            if UIScreen.main.nativeBounds.height == 2732{
                return 250
            }else if UIScreen.main.nativeBounds.height == 2048{
                return 200
            }else{
                return 116
            }
            
        }else if indexPath.row == 2 {
           
            
            if UIScreen.main.nativeBounds.height == 2732{
                return 182
            }else if UIScreen.main.nativeBounds.height == 2048{
                return 162
            }else{
                return 78
            }
            
            //return 78
            
        } else if indexPath.row == 3 {
            
            
            if UIScreen.main.nativeBounds.height == 2732{
                return 182
            }else if UIScreen.main.nativeBounds.height == 2048{
                return 162
            }else{
                return 100
            }
           
            
        }else if indexPath.row == 4 {
            
            if UIScreen.main.nativeBounds.height == 2732{
                return 182
            }else if UIScreen.main.nativeBounds.height == 2048{
                return 162
            }else{
                return 100
            }
            
        }else if indexPath.row == 5 {
            
            if UIScreen.main.nativeBounds.height == 2732{
                return 100
            }else if UIScreen.main.nativeBounds.height == 2048{
                return 100
            }else{
                return 70
            }
            
        }else if indexPath.row == 6 {
            
            if UIScreen.main.nativeBounds.height == 2732{
                return 170
            }else if UIScreen.main.nativeBounds.height == 2048{
                return 170
            }else{
                return 80
            }
            
        }else{
            
            return tableView.frame.size.height
            
        }
    }
    
   
        
   
    
}

extension String {
    var westernArabicNumeralsOnly: String {
        let pattern = UnicodeScalar("0")..."9"
        print("Pattern = \(pattern)")
        return String(unicodeScalars.flatMap {  pattern ~= $0 ? Character($0) : nil })
    }
}

extension ScheduleTableViewController :GMSPlacePickerViewControllerDelegate {
    
   
    
    func placePicker(_ viewController: GMSPlacePickerViewController, didPick place: GMSPlace) {
        // Dismiss the place picker, as it cannot dismiss itself.
        viewController.dismiss(animated: true, completion: nil)
        
        SelectedPlaceInfo = [place.name, String(place.coordinate.latitude ), String(place.coordinate.longitude) ]
        
        if place.formattedAddress == nil {
            print("Address not found")
            SelectedPlaceInfo.append("Address not found")
        }else{
            print("Address = \(place.formattedAddress!)")
            SelectedPlaceInfo.append(place.formattedAddress!)
        }

        
        //locationInProgress  = false
        print("Place name \(SelectedPlaceInfo[0])")
        print("PlaceCLati \(SelectedPlaceInfo[1])")
        print("PlaceCLong = \(SelectedPlaceInfo[2])")
        print("PlaceAddress = \(SelectedPlaceInfo[3])")
        
        locationAddress.text = SelectedPlaceInfo[0] + ", " + SelectedPlaceInfo[3]
        locationAddress.textColor = UIColor.black
        
       
        locationView.bringSubview(toFront: labelScroll)
    }
    
    func placePickerDidCancel(_ viewController: GMSPlacePickerViewController) {
        // Dismiss the place picker, as it cannot dismiss itself.
        viewController.dismiss(animated: true, completion: nil)
        
        print("No place selected")
    }
    
    
    
    
    
    
    
}
