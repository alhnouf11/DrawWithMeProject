//
//  galleryViewController.swift
//  DrawWithMe
//
//  Created by Alhnouf F on 22/06/1442 AH.
//

import UIKit
import Firebase

struct Gallery {
    let imageKey : String?
    let date : String?
    let imageURL : String?
    let score : Int
    
}

class galleryViewController: UIViewController {
    
    @IBOutlet weak var galleryCollectionView : UICollectionView!

    var galleryArray = [Gallery]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        galleryCollectionView.delegate = self
        galleryCollectionView.dataSource = self
        
        getUserDrawings()
    }
    
    @IBAction func backButtonAction(_ sender : UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func getUserDrawings() {
        let ref = Database.database().reference().child("Trace").child(addViewController.id)
        ref.observe(.childAdded) { (snapshot) in
            if let value = snapshot.value as? [String : AnyObject] {
                let imageKey = snapshot.key
                let score = value["score"] as? String
                let date = value["date"] as? String
                let imageURL = value["imageURL"] as? String
                
                var scoreInt = Int()
                
                switch score {
                case Score.Excellent.rawValue:
                    scoreInt = 5
                case Score.VeryGood.rawValue:
                    scoreInt = 4
                case Score.Good.rawValue:
                    scoreInt = 3
                case Score.Poor.rawValue:
                    scoreInt = 2
                default:
                    scoreInt = 1
                }
                
                self.galleryArray.append(Gallery(imageKey: imageKey, date: date, imageURL: imageURL, score: scoreInt))
                

                self.galleryCollectionView.reloadData()

            }
        }
    }
    
    
    func downloadImage(urlString : String, index : Int, galleryImageView : UIImageView) {
        if let url = URL(string: urlString) {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if error == nil {
                    if let data = data {
                        let image = UIImage(data: data)
                        DispatchQueue.main.async {
                            galleryImageView.image = image
                        }
                    }
                }
            }
            task.resume()
        }
    }

  

}


extension galleryViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return galleryArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = galleryCollectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! galleryCell
        
        cell.delegate = self
        
        cell.contentView.layer.borderWidth = 1
        cell.contentView.layer.borderColor = UIColor.darkGray.cgColor
        
        if let urlString = galleryArray[indexPath.row].imageURL {
            downloadImage(urlString: urlString, index: indexPath.row, galleryImageView: cell.img)
        }
        
        for i in 1...galleryArray[indexPath.row].score {
            let star = cell.viewWithTag(i) as! UIImageView
            star.image = UIImage(systemName: "star.fill")
            star.tintColor = .orange
        }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (galleryCollectionView.frame.size.width - 10) / 3
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(galleryArray[indexPath.row].score)
        
    }
    
    
}


extension galleryViewController : GalleryCellDelegate {
    func didTapDelete(cell: galleryCell) {
        
        let alertController = UIAlertController(title: "Delete Your Drawing", message: "Are you sure to delete this drawing ?", preferredStyle: .alert)
                
        let delete = UIAlertAction(title: "Delete", style: .destructive) { (action:UIAlertAction) in
            print("You've pressed default")
            self.deleteDrawing(cell: cell)
        }

        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action:UIAlertAction) in
            print("You've pressed cancel")
        }

        alertController.addAction(delete)
        alertController.addAction(cancel)

        self.present(alertController, animated: true, completion: nil)
     
    }
    
    
    func deleteDrawing(cell : UICollectionViewCell) {
        guard let indexpath = galleryCollectionView.indexPath(for: cell) else {return}

        guard let imageKey = galleryArray[indexpath.row].imageKey else {return}

        let storage = Storage.storage().reference()
        let imageRef = storage.child("Trace").child(addViewController.id).child(imageKey)

        imageRef.delete { (error) in
            if error == nil {

                let ref = Database.database().reference().child("Trace").child(addViewController.id).child(imageKey)
                ref.removeValue { (error, reference) in
                    if error == nil {
                        self.galleryArray.remove(at: indexpath.row)
                        self.galleryCollectionView.reloadData()
                    }
                }
            }
        }
    }
    
}






protocol GalleryCellDelegate {
    func didTapDelete(cell : galleryCell)
}



class galleryCell : UICollectionViewCell {
    @IBOutlet weak var img : UIImageView!
    
    @IBOutlet weak var star1 : UIImageView!
    @IBOutlet weak var star2 : UIImageView!
    @IBOutlet weak var star3 : UIImageView!
    @IBOutlet weak var star4 : UIImageView!
    @IBOutlet weak var star5 : UIImageView!
    
    var delegate : GalleryCellDelegate?
    
    @IBAction func deleteAction(_ sender : UIButton) {
        delegate?.didTapDelete(cell: self)
    }
}
