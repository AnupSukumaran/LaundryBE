//
//  OrderSummaryTableViewCell.swift
//  Laundrybe
//
//  Created by Sukumar Anup Sukumaran on 01/12/17.
//  Copyright © 2017 Sukumar Anup Sukumaran. All rights reserved.
//

import UIKit

class OrderSummaryTableViewCell: UITableViewCell {
 
    @IBOutlet weak var serviceType: UILabel!
    
    @IBOutlet weak var categoryType: UILabel!
    
    @IBOutlet weak var itemsLabel: UILabel!
    
    @IBOutlet weak var qtyLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }

}
