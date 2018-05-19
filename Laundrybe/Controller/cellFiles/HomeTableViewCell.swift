//
//  HomeTableViewCell.swift
//  Laundrybe
//
//  Created by Sukumar Anup Sukumaran on 28/11/17.
//  Copyright © 2017 Sukumar Anup Sukumaran. All rights reserved.
//

import UIKit

class HomeTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var providerLabel: UILabel!
   // @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var imageForm: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    
    }

}
