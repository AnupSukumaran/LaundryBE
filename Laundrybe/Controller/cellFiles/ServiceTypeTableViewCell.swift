//
//  ServiceTypeTableViewCell.swift
//  Laundrybe
//
//  Created by Sukumar Anup Sukumaran on 29/11/17.
//  Copyright © 2017 Sukumar Anup Sukumaran. All rights reserved.
//

import UIKit

class ServiceTypeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imageData: UIImageView!
    
    
    @IBOutlet weak var serviceTypeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

}
