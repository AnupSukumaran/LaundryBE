//
//  ModelClassForTable.swift
//  Laundrybe
//
//  Created by Sukumar Anup Sukumaran on 08/12/17.
//  Copyright © 2017 Sukumar Anup Sukumaran. All rights reserved.
//

import UIKit


//class ContainerClass {
//
//    private var dataOfClass: MensPriceListModel?
//
//
//}
protocol  UpdateDelegate: class {
    func didUpdate(sender: ModelClassForTable)
}


class ModifiedClassMadel {
    
    private var itemOfClass: PriceListModel?
    var countLabel = 0
    
    init(itemOfClass: PriceListModel) {
        self.itemOfClass = itemOfClass
    }
    
//    var labelData: String {
//        return itemOfClass!.price
//    }
    
    
    
}

class ModelClassForTable: NSObject {
    
    var priceListNewClass = [PriceListModel]()
    
    weak var delegate: UpdateDelegate?
    
    var newTot:Double = 0
     var variValue: Int = 0
    
    
    
    override init() {
        super.init()
    }

}

extension ModelClassForTable: UITableViewDataSource {
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return priceListNewClass.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "orderListTableViewCell", for: indexPath) as! orderListTableViewCell
        
        cell.addbutton.tag = indexPath.row
        cell.MinusButton.tag = indexPath.row
        
        
        cell.countLabel.text = String(priceListNewClass[indexPath.row].countLabel)
        
        cell.priceLabel.text = "₹ " + priceListNewClass[indexPath.row].price
        
        cell.productType.text = priceListNewClass[indexPath.row].cloth
        
        
        
        cell.addbutton.addTarget(self, action: #selector(addFunc(_:)), for: .touchUpInside)
        
        cell.MinusButton.addTarget(self, action: #selector(minusFunc(_:)), for: .touchUpInside)
        
        return cell
    }
    
    
    
    @objc func addFunc(_ sender: UIButton){


        print("NEWTOTW = \(newTot)")
        newTot = newTot + Double(priceListNewClass[sender.tag].price)!


        variValue = priceListNewClass[sender.tag].countLabel

        variValue += 1

        //totalPrice.text = String(newTot)

        globalLabel.sharedInstance.totvalue = Int(newTot)

        print("globalLabel.sharedInstance.totvalue = \(globalLabel.sharedInstance.totvalue)")
        priceListNewClass[sender.tag].countLabel = variValue

     //   tableViews.orderListTabelView.reloadData()
        self.delegate?.didUpdate(sender: self)

    }



    @objc func minusFunc(_ sender: UIButton) {



        variValue = priceListNewClass[sender.tag].countLabel

        if variValue > 0 {

            newTot = newTot - Double(priceListNewClass[sender.tag].price)!

            variValue -= 1

        }else{
            print("Reached limit")
        }

       // totalPrice.text = String(newTot)
        globalLabel.sharedInstance.totvalue = Int(newTot)

        priceListNewClass[sender.tag].countLabel = variValue

        // tableViews.orderListTabelView.reloadData()
        self.delegate?.didUpdate(sender: self)

    }
    
    
    
    
    
}
