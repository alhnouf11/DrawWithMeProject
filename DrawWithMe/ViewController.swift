//
//  ViewController.swift
//  DrawWithMe
//
//  Created by Alhnouf F on 20/06/1442 AH.
//

import UIKit
import Firebase
//alhnouf
class ViewController: UIViewController {

    @IBOutlet weak var nav: UINavigationItem!
    
    @IBOutlet weak var usersCollectionView : UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if var IDs = UserDefaults.standard.object(forKey: "usersIDs") as? [String] {
            print(IDs)
        }
        
        usersCollectionView.dataSource = self
        usersCollectionView.delegate = self
        
    }


}



extension ViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = usersCollectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
//        cell.backgroundColor = .red
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let dimentions = usersCollectionView.frame.size.height
        return CGSize(width: dimentions, height: dimentions)
    }
    

}
