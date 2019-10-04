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
    var count: Int = 12 { didSet { setNeedsDisplay(); setNeedsLayout() }}
    @IBInspectable
    var figure: String = "♠️" { didSet { setNeedsDisplay(); setNeedsLayout() }}
    @IBInspectable
    var style: String = "filled" { didSet { setNeedsDisplay(); setNeedsLayout() }}
    @IBInspectable
    var color: String = "blue" { didSet { setNeedsDisplay(); setNeedsLayout() }}
    @IBInspectable
    var isSelected: Bool = false { didSet { setNeedsDisplay(); setNeedsLayout() }}
    
    var faceCardScale: CGFloat = SizeRatio.faceCardImageSizeToBoundsSize { didSet { setNeedsDisplay() } }
    
//    @objc func adjustFaceCardScale(byHandlingGestureRecognizedBy recognizer: UIPinchGestureRecognizer) {
//        switch recognizer.state {
//        case .changed,.ended:
//            faceCardScale *= recognizer.scale
//            recognizer.scale = 1.0
//        default:
//            break
//        }
//    }
    
    private func centeredAttributedString(_ string: String, fontSize: CGFloat) -> NSAttributedString {
        var font = UIFont.preferredFont(forTextStyle: .body).withSize(fontSize)
        font = UIFontMetrics(forTextStyle: .body).scaledFont(for: font)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        return NSAttributedString(string: string,
                                  attributes: [.paragraphStyle: paragraphStyle,
                                               .font: font])
    }
    
    private var tempString: NSAttributedString {
        return centeredAttributedString(countString + "\n" +
            figure + "\n" + style + "\n" + color, fontSize: cornerFontSize)
    }
    
    private lazy var centerLabel = createCornerLabel()
    
    private func createCornerLabel() -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        addSubview(label)
        return label
    }
    
    private func configureCornerLabel(_ label: UILabel) {
        label.attributedText = tempString
        label.frame.size = frame.size
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setNeedsLayout()
        setNeedsDisplay()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        configureCornerLabel(centerLabel)
        centerLabel.frame.origin = bounds.origin
    }
    
    override func draw(_ rect: CGRect) {
        let roundedRectPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        UIColor.white.setFill()
        roundedRectPath.addClip()
        roundedRectPath.fill()
    }
}

extension CardView {
    private struct SizeRatio {
        static let cornerFontSizeToBoundsHeight: CGFloat = 0.15
        static let cornerRadiusToBoundsHeight: CGFloat = 0.06
        static let cornerOffsetToCornerRadius: CGFloat = 0.33
        static let faceCardImageSizeToBoundsSize: CGFloat = 0.85
    }
    
    private var cornerRadius: CGFloat {
        return bounds.size.height * SizeRatio.cornerRadiusToBoundsHeight
    }
    private var cornerOffset: CGFloat {
        return cornerRadius * SizeRatio.cornerOffsetToCornerRadius
    }
    private var cornerFontSize: CGFloat {
        return bounds.size.height * SizeRatio.cornerFontSizeToBoundsHeight
    }
    
    private var countString: String {
        switch count {
        case 0...2: return String(count + 1)
        default: return "?"
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
