//
//  UserDefaultsManager.swift
//  userdefaults
//
//  Created by Sukumar Anup Sukumaran on 12/12/17.
//  Copyright © 2017 Jad Habal. All rights reserved.
//

import Foundation

class UserDeafultsManager {
    
    
   
//Get all saved users objects and return them as UserModel array
    static func getAllUser()->[UserModel] {
     //   print("KEYVALUEID = \(globalLabel.sharedInstance.proID)")
        UserDefaults.standard.removeObject(forKey: "Cat")
        if let all = UserDefaults.standard.array(forKey: "Cat" ) as? [Dictionary<String, Any>] {
            
            return all.map{UserModel.init(dict: $0)}
        }
        
        return []
    }
    
    // Insert newUser
    static func insertUser(item:String, price:String, category:String, quantity:String, serviceType:String) -> Bool {
        print("KEYVALUES = \(item) - \(price) - \(category) - \(quantity) - \(serviceType)")
        let newUserModel = UserModel.init(item: item, price: price, category: category, quantity: quantity, serviceType: serviceType)
        
       print("NEWUSerModel = \(newUserModel.item)")
      
        var all = getAllUser()
        all.append(newUserModel)
        
      
        UserDefaults.standard.set(all.map{$0.dict}, forKey: "Cat")
        
        //Save the changes to store now
        
        return UserDefaults.standard.synchronize()
    }
    
    // delete User
    
//    static func deleteUser(item:String) -> Bool{
//        print("HIT3")
//        var all = getAllUser()
//        let index = all.index{$0.item == item}
//
//        //Found the index
//        if index != nil{
//            all.remove(at: index!)
//
//            UserDefaults.standard.set(all.map{$0.dict}, forKey: "Cat")
//            UserDefaults.standard.synchronize()
//            return true
//        }else{
//            return false
//        }
//    }
    
//    static var currentBackgroundName:String?{
//
//        set{
//            UserDefaults.standard.set(newValue, forKey: "currentBackgroundNameKey")
//        }
//
//        get{
//            return UserDefaults.standard.string(forKey: "currentBackgroundNameKey")
//        }
//    }
    
}

// in order to make working correctly we need to create a model for our object/dictionary we want to save, delete

class UserModel: NSObject {
    
    var item: String
    var price: String
    var category: String
    var quantity: String
    var serviceType: String
    
    init(item:String, price:String, category:String, quantity:String, serviceType:String) {
        self.item = item
        self.price = price
        self.category = category
        self.quantity = quantity
        self.serviceType = serviceType
        super.init()
    }
    
    
    
   init(dict:[String:Any]) {
        self.item = ""
        self.price = ""
        self.category = ""
        self.quantity = ""
        self.serviceType = ""
        super.init()
        self.setValuesForKeys(dict)
    }
    
    var dict:[String:Any]{
        
        return self.dictionaryWithValues(forKeys: ["item", "price", "category", "quantity", "serviceType"])
    }
    
}
