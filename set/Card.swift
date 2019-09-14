//
//  Card.swift
//  set
//
//  Created by Roman Zakharov on 14/09/2019.
//  Copyright © 2019 Roman Zakharov. All rights reserved.
//

import Foundation

struct Card {
    let figure: FigureType
    let count: FigureCount
    let style: FigureStyle
    let color: FigureColor
}

enum FigureType: CaseIterable {
    case triangle
    case square
    case circle
}

enum FigureCount: Int, CaseIterable {
    case one = 1
    case two = 2
    case three = 3
}

enum FigureStyle: CaseIterable {
    case filled
    case striped
    case outlined
}

enum FigureColor: CaseIterable {
    case blue
    case green
    case red
}
