//
//  drawingLevelViewController.swift
//  DrawWithMe
//
//  Created by Alhnouf F on 22/06/1442 AH.
//

import UIKit

class drawingLevelViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        
    }
    

    
    @IBAction func drawingLevelAction( _ sender : UIButton) {
        TracingVC.drawName = (sender.titleLabel?.text)!
        
        print("TracingVC.drawName :", TracingVC.drawName)
        
        let vc = TracingVC()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func homdAction (_ sender : UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    

}
