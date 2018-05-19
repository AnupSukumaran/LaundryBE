//
//  GradientColourClass.swift
//  Laundrybe
//
//  Created by Sukumar Anup Sukumaran on 27/11/17.
//  Copyright © 2017 Sukumar Anup Sukumaran. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable final class GradientView2: UIView {
    
    private let gradient = CAGradientLayer()
    
    @IBInspectable var startColor: UIColor = UIColor.clear {
        didSet {
            updateColors()
        }
    }
    
    
    @IBInspectable var endColor: UIColor = UIColor.clear {
        didSet {
            updateColors()
        }
    }
    
    // initializers
    
    
    override init(frame : CGRect) {
        super.init(frame : frame)
        
        configureGradient()
    }
    
  
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        configureGradient()
    }
    
    private func configureGradient() {
       // gradient.frame = bounds
        gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 2.0 , y: 0.0)
        updateColors()
        layer.insertSublayer(gradient, at: 0)
    }
    

    
    
    private func updateColors() {
        gradient.colors = [startColor.cgColor, endColor.cgColor]
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradient.frame = bounds
    }

}

