//
//  OffersTableViewCell.swift
//  Laundrybe
//
//  Created by Sukumar Anup Sukumaran on 19/12/17.
//  Copyright © 2017 Sukumar Anup Sukumaran. All rights reserved.
//

import UIKit

class OffersTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var imageBanner: UIImageView!
    
    @IBOutlet weak var promoCode: UILabel!
    
    @IBOutlet weak var titleDiscLabel: UILabel!
    
    @IBOutlet weak var expiryLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
   
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

}
