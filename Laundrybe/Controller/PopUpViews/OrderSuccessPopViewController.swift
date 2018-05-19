//
//  OrderSuccessPopViewController.swift
//  Laundrybe
//
//  Created by Sukumar Anup Sukumaran on 18/12/17.
//  Copyright © 2017 Sukumar Anup Sukumaran. All rights reserved.
//

import UIKit

protocol  OrderPopUpControllerDelegate: class {
    func enableUnwind()
    
}

class OrderSuccessPopViewController: UIViewController {

    weak var delegate:OrderPopUpControllerDelegate?
    
    
    @IBOutlet weak var orderIDLabel: UILabel!
    var orderId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        
       
        
       showAnimate()
    }
    
    override func viewWillLayoutSubviews() {
        print("Order = \(orderId)")
         orderIDLabel.text = "OrderId: " + orderId
    }
    
    @IBAction func okAction(_ sender: Any) {
        
        removeAnimate()
        delegate?.enableUnwind()
        
        
    }
    
    
    func showAnimate()
    {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
    func removeAnimate()
    {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
        }, completion:{(finished : Bool)  in
            if (finished)
            {
                self.view.removeFromSuperview()
            }
        });
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    

  

}
