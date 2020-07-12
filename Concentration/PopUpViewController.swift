//
//  PopUpViewController.swift
//  Concentration
//
//  Created by Max Sabadyshyn on 6/11/19.
//  Copyright © 2019 Maksym Sabadyshyn. All rights reserved.
//

import UIKit

class PopUpViewController: UIViewController {

    @IBOutlet weak var popUp: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        popUp.layer.cornerRadius = 24
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.75)
    }
    
    @IBAction func closePopUp(_ sender: UIButton) {
         self.view.removeFromSuperview()
    }
}
