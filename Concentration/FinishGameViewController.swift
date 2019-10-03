//
//  FinishGameViewController.swift
//  Concentration
//
//  Created by Max Sabadyshyn on 6/12/19.
//  Copyright © 2019 Maksym Sabadyshyn. All rights reserved.
//

import UIKit
import Cheers

class FinishGameViewController: UIViewController {
 
    @IBOutlet weak var popUp: UIView!
    @IBAction func finishGameButtonPressed(_ sender: UIButton) {
          //exit(0)
          self.view.removeFromSuperview()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        popUp.layer.cornerRadius = 24
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.75)
        let confetti = CheerView()
        view.addSubview(confetti)
        
        // Configure
        confetti.config.particle = .confetti(allowedShapes: Particle.ConfettiShape.all)
        
        
        // Start
        confetti.start()
        

        // Do any additional setup after loading the view.
    }
}
