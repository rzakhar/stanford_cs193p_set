//
//  Card.swift
//  set
//
//  Created by Roman Zakharov on 14/09/2019.
//  Copyright © 2019 Roman Zakharov. All rights reserved.
//

import Foundation

struct Card: Equatable, CustomStringConvertible {
    var description: String { return "\(count) \(style) \(color) \(figure)" }

    let figure: FigureType
    let count: FigureCount
    let style: FigureStyle
    let color: FigureColor

    enum FigureType: String, CaseIterable {
        case triangle
        case square
        case circle
    }

    enum FigureCount: Int, CaseIterable {
        case one
        case two
        case three
    }

    enum FigureStyle: String, CaseIterable {
        case filled
        case striped
        case outlined
    }

    enum FigureColor: String, CaseIterable {
        case blue
        case green
        case red
    }
}
