//
//  addViewController.swift
//  DrawWithMe
//
//  Created by Alhnouf F on 22/06/1442 AH.
//

import UIKit

class addViewController: UIViewController {

    @IBAction func backButton(_ sender: Any) {
        let vcAddUI = self.storyboard?.instantiateViewController(identifier: "switchUI")
        navigationController?.pushViewController(vcAddUI!, animated: true)
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
