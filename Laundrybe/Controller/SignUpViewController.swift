//
//  SignUpViewController.swift
//  Laundrybe
//
//  Created by Sukumar Anup Sukumaran on 27/11/17.
//  Copyright © 2017 Sukumar Anup Sukumaran. All rights reserved.
//

import UIKit
import Alamofire
import SkyFloatingLabelTextField
import SwiftValidator
import NVActivityIndicatorView


class SignUpViewController: UIViewController, ValidationDelegate, UITextFieldDelegate, NVActivityIndicatorViewable {
   
    
    

    @IBOutlet weak var buttonBox: UIButton!
    
    var activeField: UITextField?
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    
    
    var parserParams = APIService()
    
    @IBOutlet weak var nameTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var emailTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var mobileTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var passwordTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var confirmPasswordTextField: SkyFloatingLabelTextField!
    
    
    @IBOutlet weak var NameValidationLabel: UILabel!
    @IBOutlet weak var EmailValidationLabel: UILabel!
    @IBOutlet weak var mobileValidationLabel: UILabel!
    @IBOutlet weak var passwordValidationLabel: UILabel!
    @IBOutlet weak var confirmPassword: UILabel!
    
    var textFields: [SkyFloatingLabelTextField] = []
    let validator = Validator()
    
    var emailFromFacebook = ""
    var userNameFromFacebook = ""
    
    @IBOutlet weak var SignUpButton: ButtonExtender!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
         SignUpButton.isEnabled = false
        textFields = [nameTextField, emailTextField, mobileTextField, passwordTextField, confirmPasswordTextField ]
        
        for textField123 in textFields {
            textField123.delegate = self
        }
        
        buttonBox.setBackgroundImage(UIImage(named: "Box"), for: .normal)
        buttonBox.setBackgroundImage(UIImage(named: "check"), for: .selected)
        
       
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
        
        if !emailFromFacebook.isEmpty {
            nameTextField.text = userNameFromFacebook
        }
        
        if !userNameFromFacebook.isEmpty {
            emailTextField.text = emailFromFacebook
        }
        
        validator.registerField(textField: nameTextField, errorLabel: NameValidationLabel , rules: [RequiredRule(), FullNameRule()])
        validator.registerField(textField: emailTextField, errorLabel: EmailValidationLabel, rules: [RequiredRule(), EmailRule()])
        
        validator.registerField(textField: mobileTextField, errorLabel: mobileValidationLabel, rules: [RequiredRule(), PhoneNumberRule()])
        
        validator.registerField(textField: passwordTextField, errorLabel: passwordValidationLabel, rules: [RequiredRule(), PasswordRule()])
        validator.registerField(textField: confirmPasswordTextField, errorLabel: confirmPassword, rules: [RequiredRule(), ConfirmationRule(confirmField: passwordTextField)])
        validator.registerField(textField: emailTextField, errorLabel: EmailValidationLabel, rules: [RequiredRule(), EmailRule()])
        
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
    
    

    
   
  
    
    @IBAction func checkAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected {
            SignUpButton.isEnabled = true
            
        }else{
            SignUpButton.isEnabled = false
            
        }
        
    }
    
    func validationSuccessful() {
        
        self.startAnimating(message: "", type: NVActivityIndicatorType.ballSpinFadeLoader, color: .white, padding: 5)

        parserParams.getregistrationParams(_name: nameTextField.text!, _email: emailTextField.text!, _mobile: mobileTextField.text!, _password: passwordTextField.text!)
        
        parserParams.getDataWith { (result) in
            switch result{
            case .Success(let data):
                self.stopAnimating()
                print("DataLo is \(data)")
                UserDefaults.standard.set(data["user_name"]!, forKey: "UserName")
                UserDefaults.standard.set(data["user_email_id"]!, forKey: "EmailKey")
                UserDefaults.standard.set(data["user_mobile_number"]!, forKey: "MobileKey")
                UserDefaults.standard.set(data, forKey: "RegSuccess")
                
                self.callHomePage()
            case .Error(let data):
                self.stopAnimating()
                self.alertFunc(message: data)
                print("ErrorData is \(data)")
            }
            
        }
    }
    
    func alertFunc(message: String) {
        let alert = UIAlertController(title: "Login Problem", message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
        
    }
    
    func callHomePage(){
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ContainerViewController") as! ContainerViewController
        
        self.present(vc, animated: true, completion: nil)
    }
    
    func validationFailed(errors: [UITextField : ValidationError]) {
         print("Validation FAILED!")
    }
    
    @IBAction func signUpAction(_ sender: Any) {
        
        self.view.endEditing(true)
        validator.validate(delegate: self)
     
    }
    
    
    @IBAction func LogInAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
    
    
    
    
    

}
