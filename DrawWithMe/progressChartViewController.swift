//
//  progressChartViewController.swift
//  DrawWithMe
//
//  Created by Alhnouf F on 22/06/1442 AH.
//

import UIKit
import Firebase

struct ScoreChart {
    let date : String?
    let score : String?
    let level : String?
}

class progressChartViewController: UIViewController {
    
    @IBOutlet weak var chart1StackView : UIStackView!
    @IBOutlet weak var chart2StackView : UIStackView!
    @IBOutlet weak var chart3StackView : UIStackView!

    @IBOutlet var chartView : [UIView]!
    
    @IBOutlet weak var profileImage : UIImageView!
    @IBOutlet weak var nameLabel : UILabel!
    
    var beginnerArray = [ScoreChart]()
    var intermediateArray = [ScoreChart]()
    var advanceArray = [ScoreChart]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = addViewController.name
        profileImage.image = addViewController.photo
        profileImage.layer.cornerRadius = 40
        
        profileImage.layer.borderWidth = 2
        profileImage.layer.borderColor = UIColor.lightGray.cgColor
        profileImage.contentMode = .scaleAspectFill

        getScoreData()
        
        
    }
    
    @IBAction func closeButton(_ sender : UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
 
    
    func getScoreData() {
        let userID = addViewController.id
        Database.database().reference().child("Trace").child(userID).observe(.value) { (snapshot) in
            if let value = snapshot.value as? [String : AnyObject] {
                
                for one in value.values {
                    let score = one["score"] as? String
                    let level = one["level"] as? String
                    let date = one["date"] as? String
                    
                    switch level {
                    case "b":
                        self.beginnerArray.append(ScoreChart(date: date, score: score, level: level))
                    case "i":
                        self.intermediateArray.append(ScoreChart(date: date, score: score, level: level))
                    default:
                        self.advanceArray.append(ScoreChart(date: date, score: score, level: level))
                    }
                }
                
                // completion
                
                self.drawChart(scoreArray: self.beginnerArray, stack: self.chart1StackView, chartColor: #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1))
                self.drawChart(scoreArray: self.intermediateArray, stack: self.chart2StackView, chartColor: #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1))
                self.drawChart(scoreArray: self.advanceArray, stack: self.chart3StackView, chartColor: #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1))
                
            }
            
            

        }
    }
    

    
    func drawChart(scoreArray : [ScoreChart], stack : UIStackView, chartColor : UIColor) {
        
        if scoreArray.count == 0 {
            let noScoreLabel : UILabel = {
                $0.text = "No Score Data Yet"
                $0.textAlignment = .center
                $0.font = UIFont(name: "Futura", size: 16)
                $0.minimumScaleFactor = 0.5
                $0.adjustsFontSizeToFitWidth = true
                $0.textColor = #colorLiteral(red: 0.370555222, green: 0.3705646992, blue: 0.3705595732, alpha: 1)
                return $0
            }(UILabel())
            stack.alignment = .fill
            stack.addArrangedSubview(noScoreLabel)
        }
        else {
            for i in scoreArray {
                let chartView : UIView = {
                    $0.translatesAutoresizingMaskIntoConstraints = false
                    $0.backgroundColor = chartColor
                    $0.alpha = 0
                    return $0
                }(UIView())
                
                let dateLabel : UILabel = {
                    $0.translatesAutoresizingMaskIntoConstraints = false
                    $0.text = i.date
                    $0.textColor = .black
                    $0.minimumScaleFactor = 0.1
                    $0.font = UIFont(name: "Futura", size: 16)
                    $0.adjustsFontSizeToFitWidth = true
                    $0.textAlignment = .center
                    return $0
                }(UILabel())
                
                
                
                chartView.addSubview(dateLabel)
                stack.addArrangedSubview(chartView)
                
                NSLayoutConstraint.activate([
                    dateLabel.topAnchor.constraint(equalTo: chartView.bottomAnchor, constant: 2),
                    dateLabel.leftAnchor.constraint(equalTo: chartView.leftAnchor, constant: 5),
                    dateLabel.rightAnchor.constraint(equalTo: chartView.rightAnchor, constant: -5),
                    
                ])
                
                switch i.score {
                case Score.Excellent.rawValue:
                    chartView.heightAnchor.constraint(equalTo: stack.heightAnchor, multiplier: 0.98).isActive = true
                case Score.VeryGood.rawValue:
                    chartView.heightAnchor.constraint(equalTo: stack.heightAnchor, multiplier: 0.8).isActive = true
                case Score.Good.rawValue:
                    chartView.heightAnchor.constraint(equalTo: stack.heightAnchor, multiplier: 0.6).isActive = true
                case Score.Poor.rawValue:
                    chartView.heightAnchor.constraint(equalTo: stack.heightAnchor, multiplier: 0.4).isActive = true
                default:
                    chartView.heightAnchor.constraint(equalTo: stack.heightAnchor, multiplier: 0.2).isActive = true
                }
                
                UIView.animate(withDuration: 2) {
                    chartView.layoutIfNeeded()
                    chartView.alpha = 1
                }
            }
        }
        
        
    }
  

}
