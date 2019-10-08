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
    
    override internal func draw(_ rect: CGRect) {
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
