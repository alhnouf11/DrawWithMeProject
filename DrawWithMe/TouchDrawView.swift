
import Foundation
import UIKit

/// A subclass of UIView which allows you to draw on the view using your fingers
open class TouchDrawView: UIView {

    /// Used to keep track of all the strokes
    internal var stack: [Stroke] = []

    /// Used to keep track of the current StrokeSettings
    fileprivate let settings = StrokeSettings()

    /// This is used to render a user's strokes
    fileprivate let imageView = UIImageView()

    /// Initializes a TouchDrawView instance
    override public init(frame: CGRect) {
        super.init(frame: frame)
        initialize(frame)
    }

    /// Initializes a TouchDrawView instance
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize(CGRect.zero)
    }

    /// Adds the subviews and initializes stack
    private func initialize(_ frame: CGRect) {
        addSubview(imageView)
        draw(frame)
    }

    /// Sets the frames of the subviews
    override open func draw(_ rect: CGRect) {
        imageView.frame = rect
    }


    /// Sets the brush's color
    open func setColor(_ color: UIColor?) {
        if color == nil {
            settings.color = nil
        } else {
            settings.color = CIColor(color: color!)
        }
    }

    /// Sets the brush's width
    open func setWidth(_ width: CGFloat) {
        settings.width = width
    }
}

// MARK: - Touch Actions

extension TouchDrawView {

    /// Triggered when touches begin
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let touch = touches.first {
            let stroke = Stroke(points: [touch.location(in: self)],
                                settings: settings)
            stack.append(stroke)


        }
    }

    /// Triggered when touches move
    override open func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
       
        if let touch = touches.first {
            let asd = touch.location(in: self)
            
            let x = Int(asd.x)
            let y = Int(asd.y)
            
            let userPoint = CGPoint(x: x, y: y)
            TracingVC.userPoints.append(userPoint)
                
        }

        
        if let touch = touches.first {
            let stroke = stack.last!
            let lastPoint = stroke.points.last
            let currentPoint = touch.location(in: self)
            drawLineWithContext(fromPoint: lastPoint!, toPoint: currentPoint, properties: stroke.settings)
            stroke.points.append(currentPoint)
        }
    }

    /// Triggered whenever touches end, resulting in a newly created Stroke
    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let stroke = stack.last!
        if stroke.points.count == 1 {
            let lastPoint = stroke.points.last!
            drawLineWithContext(fromPoint: lastPoint, toPoint: lastPoint, properties: stroke.settings)
        }
    }
}

// MARK: - Drawing

fileprivate extension TouchDrawView {

    /// Begins the image context
    func beginImageContext() {
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, UIScreen.main.scale)
    }

    /// Ends image context and sets UIImage to what was on the context
    func endImageContext() {
        imageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }

    /// Draws the current image for context
    func drawCurrentImage() {
        imageView.image?.draw(in: imageView.bounds)
    }


    /// Draws a single Stroke
    func drawStroke(_ stroke: Stroke) {
        let properties = stroke.settings
        let points = stroke.points

        if points.count == 1 {
            let point = points[0]
            drawLine(fromPoint: point, toPoint: point, properties: properties)
        }

        for i in stride(from: 1, to: points.count, by: 1) {
            let point0 = points[i - 1]
            let point1 = points[i]
            drawLine(fromPoint: point0, toPoint: point1, properties: properties)
        }
    }

    /// Draws a single Stroke (begins/ends context
    func drawStrokeWithContext(_ stroke: Stroke) {
        beginImageContext()
        drawCurrentImage()
        drawStroke(stroke)
        endImageContext()
    }

    /// Draws a line between two points
    func drawLine(fromPoint: CGPoint, toPoint: CGPoint, properties: StrokeSettings) {
        let context = UIGraphicsGetCurrentContext()
        context!.move(to: CGPoint(x: fromPoint.x, y: fromPoint.y))
        context!.addLine(to: CGPoint(x: toPoint.x, y: toPoint.y))

        context!.setLineCap(CGLineCap.round)
        context!.setLineWidth(properties.width)

        let color = properties.color
        if color != nil {
            context!.setStrokeColor(red: properties.color!.red,
                                    green: properties.color!.green,
                                    blue: properties.color!.blue,
                                    alpha: properties.color!.alpha)
            context!.setBlendMode(CGBlendMode.normal)
        } else {
            context!.setBlendMode(CGBlendMode.clear)
        }

        context!.strokePath()
    }

    /// Draws a line between two points (begins/ends context)
    func drawLineWithContext(fromPoint: CGPoint, toPoint: CGPoint, properties: StrokeSettings) {
        beginImageContext()
        drawCurrentImage()
        drawLine(fromPoint: fromPoint, toPoint: toPoint, properties: properties)
        endImageContext()
    }
}
