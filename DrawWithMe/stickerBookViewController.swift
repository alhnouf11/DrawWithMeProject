//
//  stickerBookViewController.swift
//  DrawWithMe
//
//  Created by Alhnouf F on 22/06/1442 AH.
//

import UIKit
import Firebase

class stickerBookViewController: UIViewController {

    var stickersURL = [String]()
    
    @IBOutlet weak var stickersCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()

        stickersCollectionView.dataSource = self
        
        Database.database().reference().child("MyStickers").child(addViewController.id).observe(.childAdded) { (snapshot) in
            if let value = snapshot.value as? [String : AnyObject] {
    
//                for i in value.values {
                    if let stickerStringURL = value["imageURL"] as? String {
                        self.stickersURL.append(stickerStringURL)
                    }
//                }
                self.stickersCollectionView.reloadData()
            }
        }
    }
    

    @IBAction func backButtonAction(_ sender : UIButton) {
        self.dismiss(animated: true, completion: nil)
    }


}

class stickerCell : UICollectionViewCell {
    @IBOutlet weak var stickerImageView : UIImageView!
}

extension stickerBookViewController : UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return stickersURL.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! stickerCell
        
        let stringURL = stickersURL[indexPath.row]
        let url = URL(string: stringURL)
        
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error == nil {
                if let imageData = data {
                    let image = UIImage(data: imageData)
                    DispatchQueue.main.async {
                        cell.stickerImageView.image = image
                    }
                }
            }
        }.resume()

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200, height: 200)
    }


}
