//
//  HomeViewController.swift
//  Laundrybe
//
//  Created by Sukumar Anup Sukumaran on 27/11/17.
//  Copyright © 2017 Sukumar Anup Sukumaran. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import SwiftValidator
import NVActivityIndicatorView
import FBSDKLoginKit
import Google
import BWWalkthrough




class HomeViewController: UIViewController,ValidationDelegate, UITextFieldDelegate, NVActivityIndicatorViewable, GIDSignInUIDelegate, GIDSignInDelegate, BWWalkthroughViewControllerDelegate{
    
    
   
    //FBSDKLoginButtonDelegate
    
    
    
    @IBOutlet weak var emailTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var passwordTextField: SkyFloatingLabelTextField!
    
    
    @IBOutlet weak var emailValidationLabel: UILabel!
    
    @IBOutlet weak var passwordValidationLabel: UILabel!
 //   @IBOutlet weak var facebookLoginButton: UIButton!
 
    
var textFields: [SkyFloatingLabelTextField] = []
    
     let validator = Validator()
    
    
  
    
     var parserParams = APIService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        textFields = [emailTextField, passwordTextField]
        

        var configureError: NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
      


        if configureError != nil {
            print(configureError!)
            return
        }
        
   

        for textField123 in textFields {
            textField123.delegate = self
        }
        
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
        
        validator.registerField(textField: emailTextField, errorLabel: emailValidationLabel , rules: [RequiredRule(), EmailRule()])
        validator.registerField(textField: passwordTextField, errorLabel: passwordValidationLabel, rules: [RequiredRule(), PasswordRule()])

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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let userDefaults = UserDefaults.standard

        if !userDefaults.bool(forKey: "walkthroughPresented") {

            showWalkthrough()


        }
        

    }
    

    
    
    
    func showWalkthrough() {
        let stb = UIStoryboard(name: "Main", bundle: nil)
        let walkthrough = stb.instantiateViewController(withIdentifier: "walk0") as! BWWalkthroughViewController

        let page_one = stb.instantiateViewController(withIdentifier: "walk1") as UIViewController
        let page_two = stb.instantiateViewController(withIdentifier: "walk2") as UIViewController
        let page_three = stb.instantiateViewController(withIdentifier: "walk3") as UIViewController
        let page_four = stb.instantiateViewController(withIdentifier: "walk4") as UIViewController

        // Attach the pages to the master
        walkthrough.delegate = self
        walkthrough.add(viewController:page_one)
        walkthrough.add(viewController:page_two)
        walkthrough.add(viewController:page_three)
        walkthrough.add(viewController:page_four)


        self.present(walkthrough, animated: true, completion: nil)

    }

    func walkthroughPageDidChange(_ pageNumber: Int) {
        print("Current Page \(pageNumber)")
    }

    func walkthroughCloseButtonPressed() {
        print("WOrkingHere")
        let userDefaults = UserDefaults.standard
        userDefaults.set(true, forKey: "walkthroughPresented")
        userDefaults.synchronize()
        self.dismiss(animated: true, completion: nil)
    }
    
    func alertFunc() {
        let alert = UIAlertController(title: "Login Problem", message: "Wrong username or password", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
        
    }
    
    
    
    
    
    @IBAction func googleLoginAction(_ sender: Any) {
        
        self.startAnimating(message: "", type: NVActivityIndicatorType.ballSpinFadeLoader, color: .white, padding: 5)
        
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signIn()
        
    }
    
    func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {
        
    }

    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        self.present(viewController, animated: true, completion: nil)
    }

    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if (error == nil) {
            // Perform any operations on signed in user here.
            let userId = user.userID                  // For client-side use only!
            let idToken = user.authentication.idToken // Safe to send to the server
            let fullName = user.profile.name
            let givenName = user.profile.givenName
            let familyName = user.profile.familyName
            let email = user.profile.email

            print("\(userId!) - \(idToken!) - \(fullName!) - \(givenName!) - \(familyName!) - \(email!)")
            
            self.FaceEmail = email!
            print("FaceEmail = \(self.FaceEmail)")
            self.FaceUsername = fullName!
            print("FaceUsername = \(self.FaceUsername)")
            
            self.parserParams.email = self.FaceEmail
            
            if !self.FaceEmail.isEmpty {
                self.callingUrlForProfileCheck()
            }
        } else {
            self.stopAnimating()
            print("Error while loggin in = \(error.localizedDescription)")
        }
    }
    
    

    
    @IBAction func facebookLoginAction(_ sender: Any) {
        
        
        FBSDKLoginManager().logIn(withReadPermissions: ["email", "public_profile"], from: self) { (result, err) in
            
            
            if err != nil {
                
                 self.stopAnimating()
                print("Custom FB Login failed:", err!.localizedDescription)
                return
                
            }
            
            self.showEmailAddress()
   
        }
        
    }
    
     var FaceEmail = ""
    var FaceUsername = ""
    
    func showEmailAddress() {
        
       
        self.startAnimating(message: "", type: NVActivityIndicatorType.ballSpinFadeLoader, color: .white, padding: 5)
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id, name, email"]).start { (connection, result, err) in
            if err != nil {
                self.stopAnimating()
                print("Failed to start graph request:", err!)
                return
            }
           
            
            print(result!)
           let resultsDic = result as! NSDictionary
            
            self.FaceEmail = resultsDic.value(forKey: "email") as! String
            print("FaceEmail = \(self.FaceEmail)")
            self.FaceUsername = resultsDic.value(forKey: "name") as! String
            print("FaceUsername = \(self.FaceUsername)")
            
            self.parserParams.email = self.FaceEmail
            
            if !self.FaceEmail.isEmpty {
                self.callingUrlForProfileCheck()
            }else{
                self.stopAnimating()
            }
        }
        
    }
    
    
    func callingUrlForProfileCheck() {
        
       //  self.startAnimating(message: "", type: NVActivityIndicatorType.ballSpinFadeLoader, color: .white, padding: 5)
        
        parserParams.checkProfile { (result) in
            switch result {
            case .Success(let data):
                UserDefaults.standard.set(data["user_name"]!, forKey: "UserName")
                UserDefaults.standard.set(data["user_email_id"]!, forKey: "EmailKey")
                UserDefaults.standard.set(data["user_mobile_number"]!, forKey: "MobileKey")
                UserDefaults.standard.set(data, forKey: "LoginSuccess")
                self.callHomePage()
                self.stopAnimating()
            case .Error(let data):
                self.stopAnimating()
                if data == "FrontFail"{
                    self.callingRegPage()
                }
//                else{
//                    self.stopAnimating()
//                    self.alertFunc(message: data)
//                }

            }
        }
        
    }
    
//    func alertFunc(message: String) {
//        let alert = UIAlertController(title: "Message", message: message, preferredStyle: UIAlertControllerStyle.alert)
//        
//        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
//        present(alert, animated: true, completion: nil)
//        
//    }
    
    
    func callingRegPage() {
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        
        vc.emailFromFacebook = self.FaceEmail
        vc.userNameFromFacebook = self.FaceUsername
        
        self.present(vc, animated: true, completion: nil)
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
        
    }
    
    
    func validationSuccessful() {
        
         self.startAnimating(message: "", type: NVActivityIndicatorType.ballSpinFadeLoader, color: .white, padding: 5)
        parserParams.getLoginParams(_email: emailTextField.text!, _password: passwordTextField.text!)
        
        parserParams.getDataForLogin { (result) in
            switch result{
            case .Success(let data):
                print("Data is \(data["user_name"]!)")
                UserDefaults.standard.set(data["user_name"]!, forKey: "UserName")
                UserDefaults.standard.set(data["user_email_id"]!, forKey: "EmailKey")
                UserDefaults.standard.set(data["user_mobile_number"]!, forKey: "MobileKey")
                UserDefaults.standard.set(data, forKey: "LoginSuccess")
                self.callHomePage()
                self.stopAnimating()
            case .Error(let data):
                print("Data is \(data)")
                self.alertFunc()
                self.stopAnimating()
            }
        }
        
        
        
    }
    
    
    func callHomePage(){
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ContainerViewController") as! ContainerViewController
        
        self.present(vc, animated: true, completion: nil)
    }
    
    func validationFailed(errors: [UITextField : ValidationError]) {
        print("Validation FAILED!")
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        validator.validateField(textField: textField){ error in
            if error == nil {
                // Field validation was successful
            } else {
                // Validation error occurred
            }
        }
        return true
    }
    
    @IBAction func SignIn(_ sender: Any) {
        self.view.endEditing(true)
        validator.validate(delegate: self)
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    

    
}
