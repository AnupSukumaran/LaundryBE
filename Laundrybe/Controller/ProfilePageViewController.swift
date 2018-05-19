//
//  ProfilePageViewController.swift
//  Laundrybe
//
//  Created by Sukumar Anup Sukumaran on 25/12/17.
//  Copyright © 2017 Sukumar Anup Sukumaran. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class ProfilePageViewController: UIViewController, UITextFieldDelegate {
    
    var textFields: [SkyFloatingLabelTextField] = []
    
    @IBOutlet weak var userTextField: SkyFloatingLabelTextField!
    
    @IBOutlet weak var emailTextField: SkyFloatingLabelTextField!
    
    @IBOutlet weak var mobileNumber: SkyFloatingLabelTextField!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    var activeField: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textFields = [userTextField, emailTextField, mobileNumber]
        
      
        
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.tintColor = UIColor.white
        let fontDictionary = [ NSAttributedStringKey.foregroundColor:UIColor.white, NSAttributedStringKey.font: UIFont(name: "Arial Rounded MT Bold", size: 18.0)!  ]
        
        self.navigationController?.navigationBar.titleTextAttributes = fontDictionary
        self.navigationController?.navigationBar.setBackgroundImage(imageLayerForGradientBackground(), for: UIBarMetrics.default)
       
       
         for textField123 in textFields {
            textField123.delegate = self
            
           
        }
        
        if let userName = UserDefaults.standard.object(forKey: "UserName") as? String {
            print("User")
            userTextField.text = userName
        }
        
        if let emailText = UserDefaults.standard.object(forKey: "EmailKey") as? String {
            emailTextField.text = emailText
        }
        
        if let mobileNum = UserDefaults.standard.object(forKey: "MobileKey") as? String {
             mobileNumber.text = mobileNum
        }
        
        registerForKeyboardNotifications()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
        
    }
    
    @objc func dismissKeyboard() {
        print("IAMTOUCHED")
        for textField123 in textFields {
            textField123.resignFirstResponder()
        }
        
    }
    
    
    @IBAction func logoutAction(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "RegSuccess")
        UserDefaults.standard.removeObject(forKey: "LoginSuccess")
       
        
        print("Removed")
        callHomeView()
    }
    
    func callHomeView() {
        
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        
        present(vc, animated: true, completion: nil)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let userName = UserDefaults.standard.object(forKey: "UserName") as? String {
            userTextField.text = userName
        }
        
        if let emailText = UserDefaults.standard.object(forKey: "EmailKey") as? String {
            emailTextField.text = emailText
        }
        
        if let mobileNum = UserDefaults.standard.object(forKey: "MobileKey") as? String {
            mobileNumber.text = mobileNum
        }
    }
    
    
   
    @IBAction func MenuAtion(_ sender: UIBarButtonItem) {
        if let container = self.so_containerViewController {
            container.isSideViewControllerPresented = true
        }
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
        
//        print("ViewHeight = \(self.view.frame)")
        
        var aRect : CGRect = self.view.frame
//        print("aRect = \(aRect)")
//        print("aRect.size.height = \(aRect.size.height)")
//        print("keyboardSize!.height = \(keyboardSize!.height)")
        
        aRect.size.height -= keyboardSize!.height
        
//        print("NEW.aRect.size.height = \(aRect.size.height)")
//
//        print("aRect.contains(activeField!.frame.origin) = \(aRect.contains(activeField!.frame.origin))")
//
//        print("activeField!.frame.origin = \(activeField!.frame.origin)")
//        print("activeField = \(String(describing: activeField))")
        
        
        if activeField != nil
        {
          //  print("aRect.contains(activeField!.frame.origin) = \(aRect.contains(activeField!.frame.origin))")
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
    
    
    @IBAction func toUpdate(_ sender: Any) {
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UpdateProfileViewController")
        
        self.so_containerViewController?.topViewController = vc
        

        
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
