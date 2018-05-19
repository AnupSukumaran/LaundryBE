//
//  UpdateProfileViewController.swift
//  Laundrybe
//
//  Created by Sukumar Anup Sukumaran on 26/12/17.
//  Copyright © 2017 Sukumar Anup Sukumaran. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import NVActivityIndicatorView

class UpdateProfileViewController: UIViewController, UITextFieldDelegate, NVActivityIndicatorViewable {
    
      var textFields: [SkyFloatingLabelTextField] = []
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var userNameTextField: SkyFloatingLabelTextField!
    
    @IBOutlet weak var mobileNumTextField: SkyFloatingLabelTextField!
    
    @IBOutlet weak var oldPasswordTextField: SkyFloatingLabelTextField!
    
    @IBOutlet weak var NewPasswordTextField: SkyFloatingLabelTextField!
    
    var activeField: UITextField?
    
    var providerApi = APIService()
    
    var email = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.tintColor = UIColor.white
        let fontDictionary = [ NSAttributedStringKey.foregroundColor:UIColor.white, NSAttributedStringKey.font: UIFont(name: "Arial Rounded MT Bold", size: 18.0)!  ]
        
        self.navigationController?.navigationBar.titleTextAttributes = fontDictionary
        self.navigationController?.navigationBar.setBackgroundImage(imageLayerForGradientBackground(), for: UIBarMetrics.default)
        
        textFields = [userNameTextField, mobileNumTextField, oldPasswordTextField, NewPasswordTextField]
        
        for textField123 in textFields {
            textField123.delegate = self
        }

        userNameTextField.text = UserDefaults.standard.object(forKey: "UserName") as? String
        mobileNumTextField.text = UserDefaults.standard.object(forKey: "MobileKey") as? String
        email = (UserDefaults.standard.object(forKey: "EmailKey") as? String)!
        
        registerForKeyboardNotifications()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
       
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
        print("IAMTOUCHED")
        for textField123 in textFields {
            textField123.resignFirstResponder()
        }
        
    }
    
    @IBAction func UpdateAction(_ sender: Any) {
        
        self.view.endEditing(true)
        
        providerApi.updateProfileParams(user_email_id: email , user_mobile_number: mobileNumTextField.text!, user_name: userNameTextField.text!)
        
        callingUrl()
        
    }
    
    func callingUrl() {
        self.startAnimating(message: "", type: NVActivityIndicatorType.ballSpinFadeLoader, color: .white, padding: 5)
        providerApi.updateProfile { (values) in
            
            switch values {
            case .Success(let data):
                self.stopAnimating()
                print("Bool  = \(data)")
                if data == "true" {
                    self.alertFunc()
                }else{
                    
                    self.alertFunc2()
                    UserDefaults.standard.set(self.userNameTextField.text!, forKey: "UserName")
                    UserDefaults.standard.set(self.mobileNumTextField.text!, forKey: "MobileKey")
                    
                }
      
            case .Error(let message):
                print("Errororr = \(message)")
                self.stopAnimating()
            }
            
            
            
        }
    }
    
    func alertFunc() {
        let alert = UIAlertController(title: "Sorry!", message: "An Error Occured! Kindly check and try again", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
        
    }
    
    func alertFunc2() {
        let alert = UIAlertController(title: "Message!", message: "Successfully updated", preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { UIAlertAction in
            
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProfilePageViewController")
            
            self.so_containerViewController?.topViewController = vc
        }
        
         alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
        
        
        
    }
    
    @IBAction func UpdatePassAction(_ sender: Any) {
        
        self.view.endEditing(true)
        
        let condition = isValidPassword(testStr: oldPasswordTextField.text!)
         let condition2 = isValidPassword(testStr: NewPasswordTextField.text!)
       
        print("COn1 = \(condition), Con2 = \(condition2)")
       
        
        if condition && condition2 {
            
            providerApi.updatePassParams(user_email_id: email, old_password: oldPasswordTextField.text!, new_password: NewPasswordTextField.text!)
            
            
            callingUrl2()
            
            
        } else {
            
            let alert = UIAlertController(title: "Message!", message: "Must be have at least 6 characters", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            
        }

        
    }
    
    func callingUrl2() {
        self.startAnimating(message: "", type: NVActivityIndicatorType.ballSpinFadeLoader, color: .white, padding: 5)
        providerApi.updatePassword { (values) in
            
            switch values {
            case .Success(let data):
                 self.stopAnimating()
                print("Bool  = \(data)")
                
                if data == "true" {
                    self.alertFunc()
                }else{
                    self.alertFunc2()
                }
               
               
                
            case .Error(let message):
                print("Errororr = \(message)")
                self.stopAnimating()
            }
            
            
            
        }
    }
    

    func isValidPassword(testStr:String?) -> Bool {
        guard testStr != nil else { return false }
      
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^.{8,}$")
        return passwordTest.evaluate(with: testStr)
    }
    
    
    
    deinit {
        deregisterFromKeyboardNotifications()
    }
    
    func registerForKeyboardNotifications()
    {
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
        //Need to calculate keyboard exact size due to Apple suggestions
        self.scrollView.isScrollEnabled = true
        let info : NSDictionary = notification.userInfo! as NSDictionary
        let keyboardSize = (info[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize!.height + 14, 0.0)
        
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
        

        
        var aRect : CGRect = self.view.frame

        
        aRect.size.height -= keyboardSize!.height
        

        
        
        if activeField != nil
        {
          
            if (!aRect.contains(activeField!.frame.origin))
            {
                self.scrollView.scrollRectToVisible(activeField!.frame, animated: true)
                
                
            }
        }
        
        
    }
    
    @objc func keyboardWillBeHidden(notification: NSNotification)
    {
        //Once keyboard disappears, restore original positions
        let info : NSDictionary = notification.userInfo! as NSDictionary
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, -keyboardSize!.height, 0.0)
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
        self.view.endEditing(true)
        self.scrollView.isScrollEnabled = false
        
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @IBAction func MenuOpt(_ sender: UIBarButtonItem) {
        
        if let container = self.so_containerViewController {
            container.isSideViewControllerPresented = true
        }
        
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
