//
//  homeViewController.swift
//  DrawWithMe
//
//  Created by Alhnouf F on 22/06/1442 AH.
//

import UIKit


class homeViewController: UIViewController {
    
    @IBOutlet weak var nameLabel : UILabel!
    @IBOutlet weak var profileButton : UIButton!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileButton.layer.cornerRadius = 40

        nameLabel.text = addViewController.name
        profileButton.setBackgroundImage(addViewController.photo, for: .normal)
        

        print(addViewController.id)
    }

    

    

}
