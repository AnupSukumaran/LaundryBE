//
//  GrandientClass.swift
//  Laundrybe
//
//  Created by Sukumar Anup Sukumaran on 30/12/17.
//  Copyright © 2017 Sukumar Anup Sukumaran. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore



class GrandientClass: CAGradientLayer {
    
  static  func gradientLayerForBounds(bounds: CGRect) -> CAGradientLayer {
        let layer = CAGradientLayer()
        layer.frame = bounds
        layer.startPoint = CGPoint(x: 0.0, y: 1.0)
        layer.endPoint = CGPoint(x: 1.0, y: 0.0)
        layer.colors = [ #colorLiteral(red: 0.4, green: 0.2705882353, blue: 0.5725490196, alpha: 1).cgColor , #colorLiteral(red: 0, green: 0.5019607843, blue: 0.5019607843, alpha: 1).cgColor]
        return layer
    }
    
  static  func searchLayerForBounds(bounds: CGRect) -> CAGradientLayer {
        let layer = CAGradientLayer()
        layer.frame = bounds
        layer.startPoint = CGPoint(x: 0.0, y: 0.0)
        layer.endPoint = CGPoint(x: 2.0, y: 0.0)
        layer.colors = [ #colorLiteral(red: 0.3725522161, green: 0.2893443704, blue: 0.5642806888, alpha: 1).cgColor,  #colorLiteral(red: 0, green: 0.5019607843, blue: 0.5019607843, alpha: 1).cgColor]
        return layer
    }
}
