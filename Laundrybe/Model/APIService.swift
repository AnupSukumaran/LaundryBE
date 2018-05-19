//
//  APIService.swift
//  Laundrybe
//
//  Created by Sukumar Anup Sukumaran on 05/12/17.
//  Copyright © 2017 Sukumar Anup Sukumaran. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

enum Result <T>{
    case Success(T)
    case Error(String)
}


class APIService: NSObject {
    
    static var sharedInstance = APIService()
    
    var params = [String:AnyObject]()
    var id = ""
    var proId = ""
    var promoField = ""
    var OrderId = ""
    var email = ""
    
    var dataKeys = [String]()
    
    func getregistrationParams(_name : String,_email : String, _mobile : String, _password : String) {
        
        params.removeAll()
        self.params = [
        
            "user_name": _name as AnyObject,
            "user_email_id": _email as AnyObject,
            "user_mobile_number": _mobile as AnyObject,
            "user_password": _password as AnyObject,
            "token": "222232424" as AnyObject
        
        ]

    }
    
    
    
    
    func getDataWith(completion: @escaping (Result<[String: AnyObject]>) -> ()) {
        
        Alamofire.request(  baseUrl.link + "registeruser", method: .post, parameters: self.params)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success:
                    print("Validation Successful")
                    let values = response.result.value as AnyObject
                    
                    guard let itemJsonArray = values["userreg"] as? [String: AnyObject] else {
                        completion(.Error("Email-Id Already Exist. Kindly check and try again."))
                        return
                    }
                    
                    completion(.Success(itemJsonArray))
//                    if let hasvalue = values["userreg"] as? NSDictionary {
//                        print("HASVALUE = \(hasvalue)")
//                        completion(.Success("registred"))
//                    }else{
//                        print("Not registered")
//                         completion(.Error("Email-Id Already Exist. Kindly check and try again."))
//                    }
                   
                case .failure(let error):
                    print("Error = \(error.localizedDescription)")
                     completion(.Error(error.localizedDescription))
                }
                
                
        }
        
    }
    
    
    func getLoginParams(_email : String, _password : String) {
        
        params.removeAll()
        self.params = [

            "user_email_id": _email as AnyObject,
            "user_password": _password as AnyObject,
   
        ]
        
        print("Params = \(self.params)")
    }
    
    func getDataForLogin(completion: @escaping (Result<[String: AnyObject]>) -> ()) {
        
        Alamofire.request( baseUrl.link + "loginuser", method: .post, parameters: self.params)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success:
                    print("Validation Successful")
                    let values = response.result.value as AnyObject
                    
                    guard let itemsJsonArray = values["userreg"] as? [String: AnyObject] else {
                        
                        completion(.Error("Something went wrong!, please try again."))
                        return
                    }
                    
                     completion(.Success(itemsJsonArray))
                    

                    
                case .failure(let error):
                    print("Error = \(error.localizedDescription)")
                    completion(.Error(error.localizedDescription))
                }
                
                
        }
        
    }
    
    // MARK: Home Page calling providers details url
    
    func getDataForHome(completion: @escaping (Result<[[String : AnyObject]]>) -> ()) {
        
        Alamofire.request( baseUrl.link + "getallproviders", method: .post, parameters: ["":""])
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success:
                    print("Validation Successful")
                    let json = response.result.value as AnyObject
                    
                    guard let itemsJsonArray = json["laundry_provider"] as? [[String: AnyObject]] else {
                         completion(.Error("missing"))
                        return
                    }
                    
                
                    completion(.Success(itemsJsonArray))
                    
                case .failure(let error):
                    print("Error = \(error.localizedDescription)")
                    completion(.Error(error.localizedDescription))
                }
                
                
        }
        
    }
    
    
//    func toGetId(id:String) {
//        
//        self.id = id
//        print("ID = \(self.id)")
//    }
    
    func getDataForServiceType(completion: @escaping (Result<[[String : AnyObject]]>) -> ()) {
        print("IDIn = \(self.id)")
        Alamofire.request( baseUrl.link + "get_providerservices/" + self.id , method: .post, parameters: ["":""])
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success:
                    print("Validation Successful")
                    let json = response.result.value as AnyObject
                    
                    
                    guard let itemsJsonArray = json["services"] as? [[String: AnyObject]] else {
                        completion(.Error("Something went wrong!, please try again."))
                        return
                    }
                    
                    
                    completion(.Success(itemsJsonArray))
                    
                case .failure(let error):
                    print("Error = \(error)")
                    completion(.Error(error.localizedDescription))
                }
                
                
        }
        
    }
    
    
    
    
    func getPriceListForMen(completion: @escaping (Result<[[String : AnyObject]]>) -> ()) {
        
        print("Proid = \(self.proId) ,  id = \(self.id)")
        
        Alamofire.request( baseUrl.link + "get_clothprice_men/\(self.proId)/\(self.id)" , method: .post, parameters: ["":""])
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success:
                    print("Validation Successful")
                    let json = response.result.value as AnyObject
                    
                    guard let itemsJsonArray = json["cloth_price"] as? [[String: AnyObject]] else {
                        completion(.Error("Something went wrong!, please try again."))
                        return
                    }
                    
                    completion(.Success(itemsJsonArray))
                    
                case .failure(let error):
                    print("Error = \(error)")
                    completion(.Error(error.localizedDescription))
                }
                
                
        }
        
    }
    
    func getPriceListForWomen(completion: @escaping (Result<[[String : AnyObject]]>) -> ()) {
        
        print("Proid = \(self.proId) ,  id = \(self.id)")
        
        Alamofire.request( baseUrl.link + "get_clothprice_women/\(self.proId)/\(self.id)" , method: .post, parameters: ["":""])
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success:
                    print("Validation Successful")
                    let json = response.result.value as AnyObject
                  
                    
                    guard let itemsJsonArray = json["cloth_price"] as? [[String: AnyObject]] else {
                      completion(.Error("Something went wrong!, please try again."))
                        return
                    }
                    
                    
                    completion(.Success(itemsJsonArray))
                    
                case .failure(let error):
                    print("Error = \(error)")
                    completion(.Error(error.localizedDescription))
                }
                
                
        }
        
    }
    
    func getPriceListForChild(completion: @escaping (Result<[[String : AnyObject]]>) -> ()) {
        
        print("Proid = \(self.proId) ,  id = \(self.id)")
        
        Alamofire.request( baseUrl.link + "get_clothprice_child/\(self.proId)/\(self.id)" , method: .post, parameters: ["":""])
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success:
                    print("Validation Successful")
                    let json = response.result.value as AnyObject
                   
                    
                    guard let itemsJsonArray = json["cloth_price"] as? [[String: AnyObject]] else {
                        completion(.Error("Something went wrong!, please try again."))
                        return
                    }
                    
                    
                    completion(.Success(itemsJsonArray))
                    
                case .failure(let error):
                    print("Error = \(error)")
                    completion(.Error(error.localizedDescription))
                }
                
                
        }
        
    }
    
    func getPriceListForHouseHold(completion: @escaping (Result<[[String : AnyObject]]>) -> ()) {
        
        print("Proid = \(self.proId) ,  id = \(self.id)")
        
        Alamofire.request( baseUrl.link + "get_clothprice_household/\(self.proId)/\(self.id)" , method: .post, parameters: ["":""])
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success:
                    print("Validation Successful")
                    let json = response.result.value as AnyObject
                    print("JSON = \(json)")
                    
                    guard let itemsJsonArray = json["cloth_price"] as? [[String: AnyObject]] else {
                        completion(.Error("Something went wrong!, please try again."))
                        return
                    }
                    
                    print("Values1234 = \(itemsJsonArray)")
                    completion(.Success(itemsJsonArray))
                    
                case .failure(let error):
                    print("Error = \(error)")
                    completion(.Error(error.localizedDescription))
                }
                
                
        }
        
    }
    
    func getOrderParams(user_name : String, user_email_id : String, user_mobile : String, provider_name : String, pick_date : String, pick_time : String, promo_code : String, promo_amount : String, address : String, sur_charges : String, payment_mode : String, area : String, total_price : String, order_cloths : String ) {
        

        let order_cloths2 = order_cloths.replacingOccurrences(of: "\\" , with: "")
        print("str2 = \(order_cloths2)")

        
        print("ORDER = \(order_cloths)")

        params.removeAll()
        self.params = [
            
            "user_name": user_name as AnyObject,
            "user_email_id": user_email_id as AnyObject,
            "user_mobile": user_mobile as AnyObject,
            
            "provider_name": provider_name as AnyObject,
            "pick_date": pick_date as AnyObject,
            "pick_time": pick_time as AnyObject,
            
            "promo_code": promo_code as AnyObject,
            "promo_amount": promo_amount as AnyObject,
            "address": address as AnyObject,
            
            "sur_charges": sur_charges as AnyObject,
            "payment_mode": payment_mode as AnyObject,
            "area": area as AnyObject,
            
            "total_price": total_price as AnyObject,
            "order_cloths": order_cloths as AnyObject
            
        ]
        
        print("NewParams = \(self.params)")
    }
    
    func sendDatatoDataB(completion: @escaping (Result<String>) -> ()) {
        
        
        
        Alamofire.request( baseUrl.link + "insertallbookingarray" , method: .post, parameters: self.params)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success:
                    print("Validation Successful")
                    let json = response.result.value as AnyObject
                    print("JSON = \(json)")
                    
                    guard let message = json["order_id"] as? String else {
                        completion(.Error("FromFront"))
                        return
                    }
                    
                    print("Values1234 = \(message)")
                    completion(.Success(message))
                    
                case .failure(let error):
                    print("Error = \(error)")
                    completion(.Error(error.localizedDescription))
                }
                
                
        }
        
    }
    
    
    func checkPromo(completion: @escaping (Result<String>) -> ()) {
        
        print("Promooooo = \(promoField)")
        
        Alamofire.request( baseUrl.link + "promovalidate" , method: .post, parameters: ["promocode": promoField])
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success:
                    print("Validation Successful")
                    let json = response.result.value as AnyObject
                    print("JSON = \(json)")
                    
                    guard let message = json["error"] as? String else {
                        completion(.Error("Something went wrong!, please try again."))
                        return
                    }
                    
                    print("Values1234 = \(message)")
                    completion(.Success(message))
                    
                case .failure(let error):
                    print("Error = \(error)")
                    completion(.Error(error.localizedDescription))
                }
                
                
        }
        
    }
    
    
    func ForOfferApi(completion: @escaping (Result<[[String : AnyObject]]>) -> ()) {
       
        
        Alamofire.request( baseUrl.link + "pull_coupon" , method: .post, parameters: ["":""])
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success:
                    print("Validation Successful")
                    let json = response.result.value as AnyObject
                    print("JSON = \(json)")
                    
                    guard let data = json["coupon_data"] as? [[String : AnyObject]] else {
                        completion(.Error("Something went wrong!, please try again."))
                        return
                    }
                    
                    print("Values1234 = \(data)")
                    completion(.Success(data))
                    
                case .failure(let error):
                    print("Error = \(error)")
                    completion(.Error(error.localizedDescription))
                }
                
                
        }
        
    }
    
    func myorderDetails(completion: @escaping (Result<[[String : AnyObject]]>) -> ()) {
        
        let email = UserDefaults.standard.object(forKey: "EmailKey") as! String
        print("Email = \(email)")
        
        Alamofire.request( baseUrl.link + "allordercpdetails" , method: .post, parameters: ["email_id": email])
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success:
                    print("Validation Successful")
                   
                    
                    let json = response.result.value as AnyObject
                    print("JSON = \(json)")
                    
                    
                    guard let data = json["Result_Output"] as? [[String : AnyObject]] else {
                        
                             completion(.Error("Something went wrong!, please try again."))
                        
                        return
                    }
                    
                    print("Values1234 = \(data)")
                    completion(.Success(data))
                    
                case .failure(let error):
                    print("Error = \(error)")
                    completion(.Error(error.localizedDescription))
                }
                
                
        }
        
    }
    
    func orderDataDetails(completion: @escaping (Result<[[String : AnyObject]]>) -> ()) {
        
       
        print("orderIdData = \(OrderId)")
        
        Alamofire.request( baseUrl.link + "ordercpdetails/\(OrderId)" , method: .post, parameters: ["":""])
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success:
                    print("Validation Successful")
                    
                    
                    let json = response.result.value as AnyObject
                    print("JSON = \(json)")
                    
                    
                    guard let data = json["booking_cp"] as? [[String : AnyObject]] else {
                        
                        completion(.Error("Something went wrong!, please try again."))
                        
                        return
                    }
                    
                    print("Values1234 = \(data)")
                    completion(.Success(data))
                    
                case .failure(let error):
                    print("Error = \(error)")
                    completion(.Error(error.localizedDescription))
                }
                
                
        }
        
    }
    
    func updateProfileParams( user_email_id : String, user_mobile_number : String, user_name : String) {
        
        params.removeAll()
        self.params = [
            
            "user_name": user_name as AnyObject,
            "user_email_id": user_email_id as AnyObject,
            "user_mobile_number": user_mobile_number as AnyObject
         
        ]
        
        print("NewParams = \(self.params)")
    }
    
    func updateProfile(completion: @escaping (Result<String>) -> ()) {
        
        
        print("NewPac = \(self.params)")
        Alamofire.request( baseUrl.link + "update_user" , method: .post, parameters: self.params)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success:
                    print("Validation Successful")
           
                    let json = response.result.value as AnyObject
                    print("JSON = \(json)")
                    
                    
                    guard let data = json["error"] as? String else {
                        
                        completion(.Error("Something went wrong!, please try again."))
                        
                        return
                    }
                    
                    print("Values1234 = \(data)")
                    completion(.Success(data))
                    
                case .failure(let error):
                    print("Error = \(error)")
                    completion(.Error(error.localizedDescription))
                }
                
                
        }
        
    }
    
    func updatePassParams( user_email_id : String, old_password : String, new_password : String) {
        
        params.removeAll()
        self.params = [
            
            "old_password": old_password as AnyObject,
            "user_email_id": user_email_id as AnyObject,
            "new_password": new_password as AnyObject
            
        ]
        
        print("NewParams = \(self.params)")
    }
    
    func updatePassword(completion: @escaping (Result<String>) -> ()) {
        
        
        print("NewPac = \(self.params)")
        Alamofire.request( baseUrl.link + "change_password" , method: .post, parameters: self.params)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success:
                    print("Validation Successful")
                    
                    let json = response.result.value as AnyObject
                    print("JSON = \(json)")
                    
                    
                    guard let data = json["error"] as? String else {
                        
                        completion(.Error("Something went wrong!, please try again."))
                        
                        return
                    }
                    
                    print("Values1234 = \(data)")
                    completion(.Success(data))
                    
                case .failure(let error):
                    print("Error = \(error)")
                    completion(.Error(error.localizedDescription))
                }
                
                
        }
        
    }
    
    func checkProfile(completion: @escaping (Result<[String : AnyObject]>) -> ()) {
        
        
        print("emailFromFace = \(email)")
        Alamofire.request( baseUrl.link + "login_gmailuser" , method: .post, parameters: ["user_email_id": email])
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success:
                    print("Validation Successful")
                    
                    let json = response.result.value as AnyObject
                    print("JSON = \(json)")
                    
                    
                    guard let data = json["userreg"] as? [String : AnyObject] else {
                        
                        completion(.Error("Something went wrong!, please try again."))
                        
                        return
                    }
                    
                    print("Values1234 = \(data)")
                    completion(.Success(data))
                    
                case .failure(let error):
                    print("Error = \(error.localizedDescription)")
                    completion(.Error(error.localizedDescription))
                }
                
                
        }
        
    }
    
    func forgottenPass(completion: @escaping (Result<String>) -> ()) {
        
        
        print("email = \(email)")
        Alamofire.request( baseUrl.link + "forgot_password" , method: .post, parameters: ["user_email_id": email])
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success:
                    print("Validation Successful")
                    
                    let json = response.result.value as AnyObject
                    print("JSON = \(json)")
                    
                    
                    guard let data = json["error"] as? String else {
                        
                        completion(.Error("Something went wrong!, please try again."))
                        
                        return
                    }
                    
                    print("Values1234 = \(data)")
                    completion(.Success(data))
                    
                case .failure(let error):
                    print("Error = \(error)")
                    completion(.Error(error.localizedDescription))
                }
                
                
        }
        
    }
    
    
    
}

