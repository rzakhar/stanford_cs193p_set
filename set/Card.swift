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
        case diamond
        case squiggle
        case oval
    }

    enum FigureCount: Int, CaseIterable {
        case one = 1
        case two = 2
        case three = 3
    }

    enum FigureStyle: String, CaseIterable {
        case solid
        case striped
        case open
    }

    enum FigureColor: String, CaseIterable {
        case red
        case green
        case purple
    }
}
