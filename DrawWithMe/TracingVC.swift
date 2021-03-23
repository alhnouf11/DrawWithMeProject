

import UIKit
import Firebase

struct Part {
    let partNum : Int?
    let img : UIImage?
    let desc : String?
}

class TracingVC: UIViewController , UIGestureRecognizerDelegate {
    
    static var userPoints = [CGPoint]()

    private static let deltaWidth = CGFloat(5.0)
    
    static var drawName = ""
    static var originalImage = UIImage()
    
//    let moonDesc = ["Moon Step #1", "Moon Step #2"]
//    let appleDesc = ["Apple Step #1", "Apple Step #2"]
//    let duckDesc = ["Duck Step #1", "Duck Step #2"]
    
    var partImages = [UIImage]()
    
    var partArray = [Part]()

    var parts = 0
    
    var currentDescription = [String]()
    
    private lazy var drawView: TouchDrawView = {
        let drawView = TouchDrawView()
        drawView.delegate = self
        drawView.setColor(.red)
        drawView.setWidth(TracingVC.deltaWidth)
        drawView.translatesAutoresizingMaskIntoConstraints = false
        drawView.backgroundColor = .clear
        return drawView
    }()
    
    
    private lazy var image: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
//        image.backgroundColor = .systemPink
        return image
    }()
    
    
    private lazy var nextButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "arrow.forward.circle.fill")
        button.setImage(image, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.imageView?.tintColor = .systemBlue
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.addTarget(self, action: #selector(self.didTapNext), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    private lazy var pinButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "arrow.forward.circle.fill")
        button.setImage(image, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.imageView?.tintColor = .systemBlue
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.addTarget(self, action: #selector(self.didTapNext), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var undoButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "pencil")
        button.setImage(image, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.imageView?.tintColor = .systemBlue
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.addTarget(self, action: #selector(self.undoEnabled), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let originalImage : UIImageView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.contentMode = .scaleAspectFit
        return $0
    }(UIImageView())
    
    let descriptionLabel : UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont.systemFont(ofSize: 18)
        $0.textAlignment = .center
        $0.numberOfLines = 0
        return $0
    }(UILabel())
    
    lazy var loadingView : UIView = {
        $0.frame = self.view.bounds
        $0.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.1)
        return $0
    }(UIView())
    
    lazy var activityIndicator : UIActivityIndicatorView = {
       $0.hidesWhenStopped = true
       $0.style = .large
       $0.center = self.loadingView.center
       $0.startAnimating()
       return $0
   }(UIActivityIndicatorView())
    
    
    var currentPoints = [CGPoint]()
    
    static var tracingLevel = ""
    
    static var stickers = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        TracingVC.userPoints.removeAll()
        
        setULayout()
        
        switch TracingVC.drawName {
        case "Moon":
            currentPoints = CorrectPoints.moonPoints
            getLevelStickers(level : "b")
            print("moonPoints")
        case "Apple":
            currentPoints = CorrectPoints.applePoints
            getLevelStickers(level : "i")
            print("applePoints")
        default:
            currentPoints = CorrectPoints.duckPoints
            getLevelStickers(level : "a")
            print("duckPoints")
        }
        
        
        let ref = Database.database().reference()
        ref.child("Drawing").observe(.childAdded) { (snapshot) in
            if let value = snapshot.value as? [String : AnyObject] {
                
                if TracingVC.drawName == value["Name"] as? String {
                    print(snapshot.key)
//                    print(value["Name"] as? String)
                    if let level = value["Level"] as? String, let originalImageURL = value["imageURL"] as? String {
                        TracingVC.tracingLevel = level
                        
                        if let url = URL(string: originalImageURL) {
                            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                                if error == nil {
                                    if let data = data {
                                        if let image = UIImage(data: data) {
                                            DispatchQueue.main.async {
                                                self.originalImage.image = image
                                                TracingVC.originalImage = image
                                            }
                                        }
                                    }
                                }
                            }
                            task.resume()
                        }
                        
                    }
                    
                    
                    ref.child("DrawingPart").child(snapshot.key).observe(.childAdded) { (partSnapshot) in
                        
                        if let partValue = partSnapshot.value as? [String  :AnyObject] {
                            if let desc = partValue["description"] as? String,let imgURL = partValue["imgURL"] as? String,let partNum = partValue["part"] as? Int {
//                                self.currentDescription.append(desc)
//                                self.descriptionLabel.text =  self.currentDescription[0]
                                
                                self.downloadImage(urlString: imgURL, desc: desc, partNum: partNum)
                                
                                self.parts += 1
                                
//                                if self.parts == partSnapshot.childrenCount {
//                                    self.loadingView.removeFromSuperview()
//                                }
                            }
                        }
                    }
                }
                
            }
        }
        

    }
    
    
    func getLevelStickers(level : String) {
        Database.database().reference().child("Stickers").child(level).observe(.childAdded) { (snapshot) in
            if let value = snapshot.value as? [String : AnyObject] {
                if let urlString = value["stickerURL"] as? String {
                    
                    guard let url = URL(string: urlString) else {return}
                    
                    let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                        if error == nil {
                            if let data = data {
                                if let image = UIImage(data: data) {
                                    TracingVC.stickers.append(image)
                                }
                            }
                        }
                    }
                    task.resume()
                }
            }
        }
    }
    
    func downloadImage(urlString : String,desc : String? , partNum : Int) {
        if let url = URL(string: urlString) {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if error == nil {
                    if let data = data {
                        if let image = UIImage(data: data) {
                        self.partImages.append(image)
                            self.partArray.append(Part(partNum: partNum, img: image, desc: desc))
//                            if partNum == 1 {
//                                print("Hello")
//                                DispatchQueue.main.async {
//                                    self.image.image = image
//                                    self.descriptionLabel.text = self.partArray.
//                                }
//                            }
                            
                            if self.parts == 2 {
                                DispatchQueue.main.async {
                                    self.loadingView.removeFromSuperview()
                                    for i in self.partArray {
                                        if i.partNum == 1 {
                                            self.descriptionLabel.text = i.desc
                                            self.image.image = i.img
                                        }
                                    }
                                }
                            }
                                
                       
                            
                        }
                    }
                }
            }
            task.resume()
        }
    }
    
    func setULayout() {
        
        view.backgroundColor = .white

        view.addSubview(image)
        view.addSubview(drawView)
        view.addSubview(nextButton)
        
        view.addSubview(originalImage)
        view.addSubview(descriptionLabel)
        
        view.addSubview(loadingView)
        loadingView.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([

            
            drawView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            drawView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            drawView.widthAnchor.constraint(equalToConstant: 512),
            drawView.heightAnchor.constraint(equalToConstant: 512),
            
            
            image.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            image.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            image.widthAnchor.constraint(equalToConstant: 512),
            image.heightAnchor.constraint(equalToConstant: 512),
            
            nextButton.widthAnchor.constraint(equalToConstant: 50),
            nextButton.heightAnchor.constraint(equalToConstant: 50),
            nextButton.rightAnchor.constraint(equalTo: view.rightAnchor,constant: -20),
            nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,constant: -20),
        
//            undoButton.widthAnchor.constraint(equalToConstant: 50),
//            undoButton.heightAnchor.constraint(equalToConstant: 50),
//            undoButton.leftAnchor.constraint(equalTo: view.leftAnchor,constant: 20),
//            undoButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 20),

            
            originalImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            originalImage.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -30),
            originalImage.widthAnchor.constraint(equalToConstant: 150),
            originalImage.heightAnchor.constraint(equalToConstant: 150),
            
            
            descriptionLabel.topAnchor.constraint(equalTo: originalImage.bottomAnchor, constant: 5),
            descriptionLabel.centerXAnchor.constraint(equalTo: originalImage.centerXAnchor),
            descriptionLabel.widthAnchor.constraint(equalTo: originalImage.widthAnchor)
            
        ])
    }
 

    
    
    var step = 0
    
    var score = 0
    
    static var scoreResul = ""
    
    static var capturedImage = UIImage()
    
    lazy var allPartsError = Array(repeating: 0, count: parts)
    lazy var allPartsLength = Array(repeating: 0, count: parts)
    var totalTamplatePoints : Double = 0
    
    var SSE = 0
    let allowedDistanceRange = 0

    
    @objc func didTapNext() {
        
        
        for i in partArray {
            if i.partNum == 2 {
                self.image.image = i.img
                self.descriptionLabel.text = i.desc
            }
        }
    
        // change next button image
        nextButton.imageView?.tintColor = #colorLiteral(red: 0, green: 0.5628422499, blue: 0.3188166618, alpha: 1)
        nextButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
        
        calculateErrorRange()
        

        if step == 2 {
            nextButton.alpha = 0
            descriptionLabel.alpha = 0
            pinButton.alpha = 0
            originalImage.alpha = 0

            UIGraphicsBeginImageContext(self.view.frame.size)
            view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)

            TracingVC.capturedImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()


            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "resultVC")
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }


        
    }
    
    func calculateErrorRange() {
        for puj in TracingVC.userPoints {
                    let x = Int(puj.x)
                    let y = Int(puj.y)
                    
                    var minDistance = 100000
                    
                    for pti in currentPoints {
                    
                        let ptiX = Int(pti.x)
                        let ptiY = Int(pti.y)
                        var distance = pow(Double((x - ptiX)), 2) + pow(Double((y - ptiY)), 2)
                        
                        distance = max(distance - Double(allowedDistanceRange), 0)
                        
                        if Int(distance) < minDistance {
                            minDistance = Int(distance)
                        }
                        SSE += minDistance
                    }
                    
                    let MSE = SSE / TracingVC.userPoints.count
                    let RMSE = Double(MSE).squareRoot()
                    
                    allPartsError[step] = Int(RMSE)
                    allPartsLength[step] = currentPoints.count
                    totalTamplatePoints += Double(currentPoints.count)
                }
                
                
                var finalTracingError = 0.0
                        
                for part in 0...1 {
                                            // 175   /   354200  = 0.000004
                    let partWeight = Double(allPartsLength[part]) / totalTamplatePoints
                    finalTracingError += (partWeight * Double(allPartsError[part]))
                    
                    print("finalTracingError : ", finalTracingError)
                    print("totalTamplatePoints : ", totalTamplatePoints)
                    print("allPartsLength[\(part)] : ", allPartsLength[part])
                    print("partWeight : ",partWeight)
                    print("\n")
                }
                
                if finalTracingError <= 2 {
                    score = 5
                    TracingVC.scoreResul = Score.Excellent.rawValue
                }
                else if finalTracingError <= 4 {
                    score = 4
                    TracingVC.scoreResul = Score.VeryGood.rawValue
                }
                else if finalTracingError <= 7 {
                    score = 3
                    TracingVC.scoreResul = Score.Good.rawValue
                }
                else if finalTracingError <= 18 {
                    score = 2
                    TracingVC.scoreResul = Score.Poor.rawValue
                }
                else {
                    score = 1
                    TracingVC.scoreResul = Score.VeryPoor.rawValue
                }
                
                print("finalTracingError : ", finalTracingError)

                print("final score : ", score)
                
        step += 1
    }
    

}


extension TracingVC: TouchDrawViewDelegate {
    
    // MARK: - TouchDrawViewDelegate

    func undoEnabled() {
        // to do
        drawView.undo()
    }

    func undoDisabled() {
        // to do
    }

    func redoEnabled() {
        // to do
    }

    func redoDisabled() {
        // to do
    }

    func clearEnabled() {
       // to do
    }

    func clearDisabled() {
        // to do
    }
    
}
