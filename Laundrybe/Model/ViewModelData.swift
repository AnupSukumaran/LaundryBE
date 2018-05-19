////
////  ViewModelData.swift
////  Laundrybe
////
////  Created by Sukumar Anup Sukumaran on 29/11/17.
////  Copyright © 2017 Sukumar Anup Sukumaran. All rights reserved.
////
//
import Foundation


class baseUrl {
    //http://mobiroidtec.in/laundry/Webservice/
    static let link = "http://laundrybe.in/laundry/Webservice/"
}

class exmpleModelData {
    
    var priceData = 0
    var countLabel = 0
    
    init(priceData: Int, countLabel: Int) {
        self.priceData = priceData
        self.countLabel = countLabel
    }
    
}

class globalLabel {
    
  static var sharedInstance = globalLabel()
    
    var totvalue = 0
    var id = ""
    var dataKey = [String]()
    var serviceID = [String]()
    var pname = ""
    var placeOrderSummaryDic = [String:[PlaceOrderModel]]()
    var placeOrderSummary = [PlaceOrderModel]()
    var placeOrderSummaryW = [PlaceOrderModel]()
    var placeOrderCombined = [PlaceOrderModel]()
    var proID = ""
}

class locationMode{
    
    var latitude = ""
    var longitude = ""
    
}
