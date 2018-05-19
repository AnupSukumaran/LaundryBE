//
//  OrderTableViewCell.swift
//  Laundrybe
//
//  Created by Sukumar Anup Sukumaran on 20/12/17.
//  Copyright © 2017 Sukumar Anup Sukumaran. All rights reserved.
//

import UIKit

class OrderTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var orderStatusLabel: UILabel!
    
    @IBOutlet weak var OrderIdLabel: UILabel!
    
    @IBOutlet weak var pickDateLabel: UILabel!
    
    @IBOutlet weak var pickTimeLabel: UILabel!
    
    @IBOutlet weak var areaLabel: UILabel!
    
    @IBOutlet weak var paymentLabel: UILabel!
    
    @IBOutlet weak var totalAmt: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
