

import UIKit

class TracingVC: UIViewController , UIGestureRecognizerDelegate {
    
    static var userPoints = [CGPoint]()

    private static let deltaWidth = CGFloat(5.0)
    
    static var drawName = ""
    static var originalImage = UIImage()
    
    let moonDesc = ["Moon Step #1", "Moon Step #2"]
    let appleDesc = ["Apple Step #1", "Apple Step #2"]
    let duckDesc = ["Duck Step #1", "Duck Step #2"]
    
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
    
    var currentPoints = [CGPoint]()
    
    static var tracingLevel = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        TracingVC.userPoints.removeAll()
        
        switch TracingVC.drawName {
        case "Moon":
            currentPoints = CorrectPoints.moonPoints
            currentDescription = moonDesc
            TracingVC.tracingLevel = "b"
        case "Apple":
            currentPoints = CorrectPoints.applePoints
            currentDescription = appleDesc
            TracingVC.tracingLevel = "i"
        default:
            currentPoints = CorrectPoints.duckPoints
            currentDescription = duckDesc
            TracingVC.tracingLevel = "a"
        }
        
        setULayout()

    }
    
    func setULayout() {
        
        view.backgroundColor = .white
        
        
        
        view.addSubview(image)
        view.addSubview(drawView)
        view.addSubview(nextButton)
  
//        view.addSubview(undoButton)
        
        view.addSubview(originalImage)
        view.addSubview(descriptionLabel)
        
        
//        TracingVC.drawName = "moon"
        
        image.image = UIImage(named: "\(TracingVC.drawName)1")
        originalImage.image = UIImage(named: "\(TracingVC.drawName)Original")
        descriptionLabel.text = currentDescription[0]
        
        TracingVC.originalImage = UIImage(named: "\(TracingVC.drawName)Original")!
        
        NSLayoutConstraint.activate([
//            drawView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//            drawView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
//            drawView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            drawView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
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
    
    var allPartsError = Array(repeating: 0, count: 2)
    var allPartsLength = Array(repeating: 0, count: 2)
    var totalTamplatePoints : Double = 0
    
    var SSE = 0
    let allowedDistanceRange = 0

    
    @objc func didTapNext() {
        let image = UIImage(named: "\(TracingVC.drawName)2")
        self.image.image = image
        
        descriptionLabel.text = currentDescription[1]
     
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
                    
                    for pti in CorrectPoints.moonPoints {
                    
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
                    allPartsLength[step] = CorrectPoints.moonPoints.count
                    totalTamplatePoints += Double(CorrectPoints.moonPoints.count)
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
