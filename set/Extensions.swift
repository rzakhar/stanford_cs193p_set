//
//  Extensions.swift
//  set
//
//  Created by Roman Zakharov on 14/09/2019.
//  Copyright © 2019 Roman Zakharov. All rights reserved.
//

import Foundation

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
            
            return filter( { $0 == firstElement } ).count == count
        }
    }
    
    var allElementsUnique: Bool {
        var arrayCopy = self
        while arrayCopy.count > 0 {
            let firstElement = arrayCopy.first!
            if arrayCopy.filter( { $0 == firstElement } ).count != 1 {
                
                return false
            } else {
                arrayCopy.remove(at: 0)
            }
        }
        
        return true
    }
}
