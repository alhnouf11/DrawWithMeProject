//
//  tracingViewController.swift
//  DrawWithMe
//
//  Created by Alhnouf F on 22/06/1442 AH.
//

import UIKit
import PencilKit

class tracingViewController: UIViewController {

    @IBOutlet weak var canvasView: UIView!
    
    var path = UIBezierPath()
    var startPoint = CGPoint()
    var touchPoint = CGPoint()
    
    
    @IBAction func eraserClear(_ sender: UIButton) {
        
        path.removeAllPoints()
        canvasView.layer.sublayers = nil
        canvasView.setNeedsDisplay()
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //background
        self.canvasView.backgroundColor = UIColor(patternImage: UIImage(named: "house")!)
        
        
        canvasView.clipsToBounds = true
        canvasView.isMultipleTouchEnabled = false
        

    }
    

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if let point = touch?.location(in: canvasView){
            startPoint = point
        }
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if let point = touch?.location(in: canvasView){
            touchPoint = point
        }
        
        path.move(to: startPoint)
        path.addLine(to: touchPoint)
        startPoint = touchPoint
        //call draw
        draw()
    }
    
    func draw(){
        let strokeLayer = CAShapeLayer()
        strokeLayer.fillColor = nil
        strokeLayer.lineWidth = 5
        strokeLayer.strokeColor = UIColor.red.cgColor
        strokeLayer.path = path.cgPath
        canvasView.layer.addSublayer(strokeLayer)
        canvasView.setNeedsDisplay()
    }
    

    
    
    

}
