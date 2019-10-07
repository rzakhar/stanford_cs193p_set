//
//  CardView.swift
//  set
//
//  Created by Roman Zakharov on 04/10/2019.
//  Copyright © 2019 Roman Zakharov. All rights reserved.
//

import UIKit

@IBDesignable
class CardView: UIView {
    
    @IBInspectable
    var count: Int = 2 { didSet { setNeedsDisplay(); setNeedsLayout() }}
    @IBInspectable
    var figure: String = "diamond" { didSet { setNeedsDisplay(); setNeedsLayout() }}
    @IBInspectable
    var style: String = "solid" { didSet { setNeedsDisplay(); setNeedsLayout() }}
    @IBInspectable
    var color: String = "red" { didSet { setNeedsDisplay(); setNeedsLayout() }}
    @IBInspectable
    var isSelected: Bool = false { didSet { setNeedsDisplay(); setNeedsLayout() }}
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setNeedsLayout()
        setNeedsDisplay()
    }
    
    private func drawCardBackground() {
        isOpaque = false
        let roundedRectPath = UIBezierPath(roundedRect: bounds.zoom(by: SizeRatio.cardScale),
                                           cornerRadius: cornerRadius)
        CardView.paperColor.setFill()
        roundedRectPath.addClip()
        roundedRectPath.fill()
        
        if isSelected {
            roundedRectPath.lineWidth = CardView.selectionWidth
            CardView.selectionColor.setStroke()
        } else {
            roundedRectPath.lineWidth = CardView.figureStrokeWidth
            CardView.cardEdgeColor.setStroke()
        }
        roundedRectPath.stroke()
    }
    
    private func drawWhiteStripes(in figureBounds: CGRect) {
        let stripesPath = UIBezierPath()
        for i in stride(from: Int(figureBounds.minX),
                        through: Int(figureBounds.maxX),
                        by: CardView.stripesDistancy) {
            stripesPath.move(to: CGPoint(x: i, y: Int(figureBounds.minY)))
            stripesPath.addLine(to: CGPoint(x: i, y: Int(figureBounds.maxY)))
        }
        CardView.paperColor.setStroke()
        stripesPath.stroke()
    }
    
    override func draw(_ rect: CGRect) {
        drawCardBackground()
        
        var figurePath = UIBezierPath()
        
        switch figure {
        case "diamond": figurePath = UIBezierPath.diamond(in: figureSize)
        case "squiggle": figurePath = UIBezierPath.squiggle(in: figureSize)
        case "oval": figurePath = UIBezierPath(roundedRect: figureSize,
                                               cornerRadius: ovalCornerRadius)
        default: break
        }
        
        figurePath.apply(CGAffineTransform(scaleX: SizeRatio.figureScale,
                                           y: SizeRatio.figureScale))
        figurePath.apply(CGAffineTransform(translationX: firstFigureOffset.x,
                                           y: firstFigureOffset.y))
        
        for _ in 0..<count {
            figurePath.lineWidth = CardView.figureStrokeWidth
            figurePath.apply(CGAffineTransform(translationX: 0,
                                               y: figureSize.height))
            
            switch style {
            case "solid":
                figureColor.setFill()
                figurePath.fill()
            case "striped":
                figureColor.setFill()
                figurePath.fill()
                drawWhiteStripes(in: figurePath.bounds)
                figureColor.setStroke()
                figurePath.stroke()
            case "open":
                figureColor.setStroke()
                figurePath.stroke()
            default: break
            }
        }
    }
}

extension CardView {
    private struct SizeRatio {
        static let cardScale: CGFloat = 0.98
        static let cornerRadiusToBoundsHeight: CGFloat = 0.06
        static let figureScale: CGFloat = 0.65
    }
    
    private var cornerRadius: CGFloat {
        return bounds.size.height * SizeRatio.cornerRadiusToBoundsHeight
    }
    
    private var figureSize: CGRect {
        return self.bounds.applying(CGAffineTransform(scaleX: 1, y: 1 / 3))
    }
    
    private var ovalCornerRadius: CGFloat {
        return figureSize.height * 0.5
    }
    
    private var firstFigureOffset: (x: CGFloat, y: CGFloat) {
        
        let translationsY: CGFloat = 0.5 - 0.5 * CGFloat(count)
        
        let offsetScale = (1 - SizeRatio.figureScale) / 2
        return (x: figureSize.width * offsetScale,
                y: figureSize.height * (translationsY + offsetScale))
    }
    
    private static let figureStrokeWidth: CGFloat = 3.0
    private static let stripesDistancy = 5
    private static let selectionWidth: CGFloat = 10.0
    private static let selectionColor = UIColor.orange
    private static let paperColor = UIColor.white
    private static let cardEdgeColor = UIColor.black
    
    private var figureColor: UIColor {
        switch color {
        case "red": return #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1)
        case "green": return #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        case "purple": return #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)
        default: return UIColor.black
        }
    }
}

extension CGRect {
    var leftHalf: CGRect {
        return CGRect(x: minX, y: minY, width: width/2, height: height)
    }
    var rightHalf: CGRect {
        return CGRect(x: midX, y: minY, width: width/2, height: height)
    }
    
    func inset(by size: CGSize) -> CGRect {
        return insetBy(dx: size.width, dy: size.height)
    }
    
    func sized(to size: CGSize) -> CGRect {
        return CGRect(origin: origin, size: size)
    }
    
    func zoom(by scale: CGFloat) -> CGRect {
        let newWidth = width * scale
        let newHeight = height * scale
        return insetBy(dx: width - newWidth, dy: height - newHeight)
    }
}

extension CGPoint {
    func offsetBy(dx: CGFloat, dy: CGFloat) -> CGPoint {
        return CGPoint(x: x + dx, y: y + dy)
    }
}

extension UIBezierPath {
    static func diamond(in rect: CGRect) -> UIBezierPath {
        let diamondPath = UIBezierPath()
        diamondPath.move(to: CGPoint(x: rect.width / 2, y: 0))
        diamondPath.addLine(to: CGPoint(x: rect.width, y: rect.height / 2))
        diamondPath.addLine(to: CGPoint(x: rect.width / 2, y: rect.height))
        diamondPath.addLine(to: CGPoint(x: 0, y: rect.height / 2))
        diamondPath.close()
        return diamondPath
    }
    
    static func squiggle(in rect: CGRect) -> UIBezierPath {
        let squigglePath = UIBezierPath()
        
        func point(_ x: CGFloat, _ y: CGFloat) -> CGPoint {
            return CGPoint(x: x / 99 * rect.width,
                           y: y / 47 * rect.height)
        }
        
        squigglePath.move(to: point(99, 3))
        squigglePath.addCurve(to: point(58, 42),
                              controlPoint1: point(108, 25),
                              controlPoint2: point(85, 49))
        squigglePath.addCurve(to: point(22, 41),
                              controlPoint1: point(47, 39),
                              controlPoint2: point(37, 30))
        squigglePath.addCurve(to: point(0, 28),
                              controlPoint1: point(5, 54),
                              controlPoint2: point(1, 46))
        squigglePath.addCurve(to: point(31, 0),
                              controlPoint1: point(0, 10),
                              controlPoint2: point(14, -2))
        squigglePath.addCurve(to: point(84, 2),
                              controlPoint1: point(54, 3),
                              controlPoint2: point(57, 20))
        squigglePath.addCurve(to: point(99, 3),
                              controlPoint1: point(90, -2),
                              controlPoint2: point(96, -5))
        
        return squigglePath
    }
}
