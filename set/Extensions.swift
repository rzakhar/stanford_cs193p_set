//
//  Extensions.swift
//  set
//
//  Created by Roman Zakharov on 14/09/2019.
//  Copyright © 2019 Roman Zakharov. All rights reserved.
//

import UIKit

extension String {
    func repeated(times: Int) -> String {
        var result = String()
        for _ in 0..<times {
            result = result + self
        }
        
        return result
    }
}

extension Array where Element : Equatable {
    var allElementsEqualOrUnique: Bool {
    
        return allElementsEqual || allElementsUnique
    }
    
    var allElementsEqual: Bool {
        if count == 0 {
            
            return true
        } else {
            let firstElement = first!
            
            return count(of: firstElement) == count
        }
    }
    
    var allElementsUnique: Bool {
        var arrayCopy = self
        while arrayCopy.count > 0 {
            let firstElement = arrayCopy.first!
            if arrayCopy.count(of: firstElement) != 1 {
                
                return false
            } else {
                arrayCopy.remove(at: 0)
            }
        }
        
        return true
    }
    
    func count(of element: Element) -> Int {
        return filter( { $0 == element } ).count
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
