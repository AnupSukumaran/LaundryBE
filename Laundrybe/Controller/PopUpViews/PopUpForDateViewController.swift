//
//  PopUpForDateViewController.swift
//  Laundrybe
//
//  Created by Sukumar Anup Sukumaran on 01/12/17.
//  Copyright © 2017 Sukumar Anup Sukumaran. All rights reserved.
//

import UIKit

protocol  DatePopUpControllerDelegate: class {
    func enableScroll()
    func pickedDate(Date: String)
}

class PopUpForDateViewController: UIViewController {
    
    
    weak var delegate: DatePopUpControllerDelegate?
    var pickedDate = ""
    
    @IBOutlet weak var datePick: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
       
        
        showAnimate()
       
    }

   
    @IBAction func selectAction(_ sender: UIButton) {
        
        removeAnimate()
        delegate?.enableScroll()
        
        let dateFor = DateFormatter()
        dateFor.dateFormat = "dd-MM-yyyy"
        pickedDate = dateFor.string(from: datePick.date)
        pickDate(date: pickedDate)
        
    }
    
    @IBAction func datePickerAction(_ sender: UIDatePicker) {
        
        print("date = \(sender.date)")
        
        let dateFor = DateFormatter()
        dateFor.dateFormat = "dd-MM-yyyy"
        pickedDate = dateFor.string(from: datePick.date)
       
     }
    
    func pickDate(date: String){
        delegate?.pickedDate(Date: date)
    }
    
    @IBAction func cancelAction(_ sender: UIButton) {
        
        removeAnimate()
        delegate?.enableScroll()
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
    
    
}
