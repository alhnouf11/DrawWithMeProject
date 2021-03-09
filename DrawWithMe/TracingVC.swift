//
//  ViewController.swift
//  Draw
//
//  Created by Faris Albalawi on 3/4/21.
//

import UIKit

class TracingVC: UIViewController {
    
    static var strokePoints = [CGPoint]()

    private static let deltaWidth = CGFloat(5.0)
    
    static var drawName = ""
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        
        switch TracingVC.drawName {
        case "Moon":
            currentPoints = CorrectPoints.moonPoints
            currentDescription = moonDesc
        case "Apple":
            currentPoints = CorrectPoints.applePoints
            currentDescription = appleDesc
        default:
            currentPoints = CorrectPoints.duckPoints
            currentDescription = duckDesc
        }
        
        setULayout()
        
//        print(CorrectPoints.moonPoints)
//        print(CorrectPoints.moonPoints.count)
  
  
    }
    
    func setULayout() {
        
        view.backgroundColor = .white
        
        
        
        view.addSubview(image)
        view.addSubview(drawView)
        view.addSubview(nextButton)
        
        view.addSubview(resultLabel)
        
        view.addSubview(undoButton)
        
        view.addSubview(originalImage)
        view.addSubview(descriptionLabel)
        
        
//        TracingVC.drawName = "moon"
        
        image.image = UIImage(named: "\(TracingVC.drawName)1")
        originalImage.image = UIImage(named: "\(TracingVC.drawName)Original")
        descriptionLabel.text = currentDescription[0]
        
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
        
            undoButton.widthAnchor.constraint(equalToConstant: 50),
            undoButton.heightAnchor.constraint(equalToConstant: 50),
            undoButton.leftAnchor.constraint(equalTo: view.leftAnchor,constant: 20),
            undoButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 20),
            
            
            resultLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            resultLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            originalImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            originalImage.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -30),
            originalImage.widthAnchor.constraint(equalToConstant: 150),
            originalImage.heightAnchor.constraint(equalToConstant: 150),
            
            
            descriptionLabel.topAnchor.constraint(equalTo: originalImage.bottomAnchor, constant: 5),
            descriptionLabel.centerXAnchor.constraint(equalTo: originalImage.centerXAnchor),
            descriptionLabel.widthAnchor.constraint(equalTo: originalImage.widthAnchor)
            
        ])
    }
    
    let resultLabel : UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont(name: "Futura", size: 40)
        return $0
    }(UILabel())

    
    
    var step = 0
    
    var score = 0
    
    // Moon1
    // Moon2
    // MoonOriginal
    
    // Apple1
    // Apple2

    
    @objc func didTapNext() {
        let image = UIImage(named: "\(TracingVC.drawName)2")
        self.image.image = image
        
        descriptionLabel.text = currentDescription[1]
     
        
        if step == 1 {
            
            for p in currentPoints {
                
                let correct = CGPoint(x: Int(p.x), y: Int(p.y))
                
                for i in TracingVC.strokePoints {
                    let x = Int(i.x)
                    let y = Int(i.y)
                    
                    if i.x == correct.x && (y) ... (y + 2) ~= Int(correct.y) {
                        print("corrrrrrreeeeeeccccttt")
                        score += 1
                    }
                }
            }
            

            let level =  Int((Double(score) / Double(currentPoints.count)) * 100.0)
            

            if level >= 81 {
                resultLabel.text = "Excellant"
            }
            
            else if level >= 61 && level <= 80  {
 
                self.resultLabel.text = "Very Good" //"Score : \(Int(self.score)) %"
            }
            
            else if level >= 41 && level <= 60  {
 
                self.resultLabel.text = "Good" //"Score : \(Int(self.score)) %"
            }
            
            else if level >= 21 && level <= 40  {
 
                self.resultLabel.text = "Poor" //"Score : \(Int(self.score)) %"
            }
            
            else {
                self.resultLabel.text = "Very Poor"
            }
        }

        else if step == 2 {
            // navigate me to score page
        }
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
