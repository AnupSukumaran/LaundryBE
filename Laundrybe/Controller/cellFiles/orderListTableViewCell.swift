//
//  orderListTableViewCell.swift
//  Laundrybe
//
//  Created by Sukumar Anup Sukumaran on 29/11/17.
//  Copyright © 2017 Sukumar Anup Sukumaran. All rights reserved.
//

import UIKit

class orderListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var addbutton: UIButton!
    
    @IBOutlet weak var MinusButton: UIButton!
    
    @IBOutlet weak var countLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var productType: UILabel!
    
    @IBOutlet weak var genderImage: UIImageView!
    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

}
