//
//  TimePopUpViewController.swift
//  Laundrybe
//
//  Created by Sukumar Anup Sukumaran on 02/12/17.
//  Copyright © 2017 Sukumar Anup Sukumaran. All rights reserved.
//

import UIKit

protocol  TimePopUpControllerDelegate: class {
    func enableScrollFromTime()
    func pickedTime(Time: String)
}

class TimePopUpViewController: UIViewController {
    
    weak var delegate: TimePopUpControllerDelegate?
    var pickedTime = ""
    
    
    @IBOutlet weak var timePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()

         self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        
        showAnimate()
        
    }

    @IBAction func selectAction(_ sender: UIButton) {
        
        removeAnimate()
        delegate?.enableScrollFromTime()
        
        let timeForm = DateFormatter()
        timeForm.dateFormat = "hh:mm a"
        pickedTime = timeForm.string(from: timePicker.date )
        pickedTime(Time: pickedTime)
    }
    
    
    @IBAction func cancelAction(_ sender: UIButton) {
        
        removeAnimate()
        delegate?.enableScrollFromTime()
        
       
    }
    
    @IBAction func timePickerAction(_ sender: UIDatePicker) {
        
        let timeForm = DateFormatter()
        timeForm.dateFormat = "hh:mm a"
        pickedTime = timeForm.string(from: timePicker.date )
        
        
    }
    
    func pickedTime(Time: String) {
        delegate?.pickedTime(Time: Time)
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
