//
//  ForgotEmailViewController.swift
//  Laundrybe
//
//  Created by Sukumar Anup Sukumaran on 29/12/17.
//  Copyright © 2017 Sukumar Anup Sukumaran. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import SwiftValidator
import NVActivityIndicatorView

class ForgotEmailViewController: UIViewController, UITextFieldDelegate, ValidationDelegate, NVActivityIndicatorViewable {
    
    
    
    @IBOutlet weak var emailTextField: SkyFloatingLabelTextField!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var emailValidationLabel: UILabel!
    
    var providerAPI = APIService()
    
    var activeField: UITextField?
    
    let validator = Validator()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        emailTextField.delegate = self
        
        validator.styleTransformers(success:{ (validationRule) -> Void in
            print("here")
            // clear error label
            validationRule.errorLabel?.isHidden = true
            validationRule.errorLabel?.text = ""
            
        }, error:{ (validationError) -> Void in
            print("error")
            validationError.errorLabel?.isHidden = false
            validationError.errorLabel?.text = validationError.errorMessage
            
        })
        
        validator.registerField(textField: emailTextField, errorLabel: emailValidationLabel, rules: [RequiredRule(), EmailRule()])
        
        
        
        registerForKeyboardNotifications()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
        
    }
    
    @objc func dismissKeyboard() {
        print("IAMTOUCHED")
        
        emailTextField.resignFirstResponder()
        
        
    }
    
    func checkReachability(){
        if currentReachabilityStatus == .reachableViaWiFi {
            
            print("User is connected to the internet via wifi.")
            
        }else if currentReachabilityStatus == .reachableViaWWAN{
            
            print("User is connected to the internet via WWAN.")
            
        } else {
            print("No internet via WWAN.")
            
            let alert = UIAlertController(title: "No Internet Connection", message: "Make sure your device is connected to the internet", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }
    }
    
    override func viewDidLayoutSubviews() {
        checkReachability()
    }
    
    @IBAction func backAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func forgotPasswordAction(_ sender: Any) {
        
        self.view.endEditing(true)
        validator.validate(delegate: self)
        
    }
    
    func validationSuccessful() {
        if currentReachabilityStatus == .notReachable {
            let alert = UIAlertController(title: "No Internet Connection", message: "Make sure your device is connected to the internet", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            
        self.startAnimating(message: "", type: NVActivityIndicatorType.ballSpinFadeLoader, color: .white, padding: 5)
        
        providerAPI.email = emailTextField.text!
        
        providerAPI.forgottenPass { (result) in
            switch result {
            case .Success(let data):
                 self.stopAnimating()
                print("DataCon = \(data)")
                 if data == "true"{
                   
                    let alert = UIAlertController(title: "Message!", message: "Your email is not Registered!", preferredStyle: UIAlertControllerStyle.alert)
                    
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                 }else{
                   
                    let alert = UIAlertController(title: "Message!", message: "New password will be sent to your email...", preferredStyle: UIAlertControllerStyle.alert)
                    
                    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { UIAlertAction in
                        self.dismiss(animated: true, completion: nil)
                    }
                    
                    alert.addAction(okAction)
                    self.present(alert, animated: true, completion: nil)
                    
                 }
                
                
            case .Error(let data):
                 self.stopAnimating()
                print("ErrorData is \(data)")
                
            }
        }
            
        }
    }
    
    func validationFailed(errors: [UITextField : ValidationError]) {
          print("Validation FAILED!")
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
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize!.height, 0.0)
        
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
        
       
        
        var aRect : CGRect = self.view.frame
        
        
        aRect.size.height -= keyboardSize!.height
        
        
        
        
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
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

    

}
