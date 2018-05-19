//
//  PersistSummary.swift
//  Laundrybe
//
//  Created by Sukumar Anup Sukumaran on 13/12/17.
//  Copyright © 2017 Sukumar Anup Sukumaran. All rights reserved.
//

import Foundation

class PersistSummary: NSObject, NSCoding {
    
    
    struct Keys {
        static let Item = "item"
        static let Price = "price"
        static let Category = "category"
        static let Quantity = "quantity"
        static let ServiceType = "serviceType"
    }
    
    private var item = ""
    private var price = ""
    private var category = ""
    private var quantity = ""
    private var serviceType = ""
    
    
    init(item: String, price: String, category: String, quantity: String, serviceType: String){
        self.item = item
        self.price = price
        self.category = category
        self.quantity = quantity
        self.serviceType = serviceType
    }
    
   
    
    func encode(with aCoder: NSCoder) {
//        aCoder.encode( globalLabel.sharedInstance.placeOrderSummary, forKey: globalLabel.sharedInstance.proID)
        
        aCoder.encode(item, forKey: Keys.Item)
        aCoder.encode(price, forKey: Keys.Price)
        aCoder.encode(category, forKey: Keys.Category)
        aCoder.encode(quantity, forKey: Keys.Quantity)
        aCoder.encode(serviceType, forKey: Keys.ServiceType)
        
        print("SAVEDCODED")
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        if let itemObj = aDecoder.decodeObject(forKey: Keys.Item) as? String {
            item = itemObj
        }
        if let priceObj = aDecoder.decodeObject(forKey: Keys.Price) as? String {
            price = priceObj
        }
        if let categoryObj = aDecoder.decodeObject(forKey: Keys.Category) as? String {
            category = categoryObj
        }
        if let quantityObj = aDecoder.decodeObject(forKey: Keys.Quantity) as? String {
            quantity = quantityObj
        }
        if let serviceTypeObj = aDecoder.decodeObject(forKey: Keys.ServiceType) as? String {
            serviceType = serviceTypeObj
        }
        
         print("DeCODED")
    }
    
    var Item: String {
        get {
            return item
        }
        set{
            item = newValue
        }
    }
    
    var Price: String {
        get {
            return price
        }
        set{
            price = newValue
        }
    }
    
    var Category: String {
        get {
            return category
        }
        set{
            category = newValue
        }
    }
    
    var Quantity: String {
        get {
            return quantity
        }
        set{
            quantity = newValue
        }
    }
    
    var ServiceType: String {
        get {
            return serviceType
        }
        set{
            serviceType = newValue
        }
    }
    
    
    
    
}











