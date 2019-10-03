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

        // Do any additional setup after loading the view.
    }
    

    @IBAction func closePopUp(_ sender: UIButton) {
         
         self.view.removeFromSuperview()
    }
     /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
