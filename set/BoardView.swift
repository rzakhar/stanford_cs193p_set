//
//  BoardView.swift
//  set
//
//  Created by Roman Zakharov on 08/10/2019.
//  Copyright © 2019 Roman Zakharov. All rights reserved.
//

import UIKit

class BoardView: UIView {

    lazy var grid = Grid(layout: .aspectRatio(2 / 3), frame: bounds)
    
    internal override func layoutSubviews() {
        super.layoutSubviews()
        let cardsCount = grid.cellCount
        grid = Grid(layout: .aspectRatio(2 / 3), frame: bounds)
        grid.cellCount = cardsCount
        
        var counter = 0
        for subview in subviews {
            subview.frame = grid[counter]!
            counter += 1
            subview.setNeedsDisplay()
        }
    }
    
    func redrawCards(cards: [Card], selectedCards: [Card]) {
        let cardsCount = cards.count
        
        grid.cellCount = cardsCount
        
        for subview in subviews {
            subview.removeFromSuperview()
        }
        
        for i in 0..<cardsCount {
            let cardFrame = grid[i]!
            let cardModel = cards[i]
            
            let cardView = CardView(frame: cardFrame)
            cardView.color = cardModel.color.rawValue
            cardView.style = cardModel.style.rawValue
            cardView.figure = cardModel.figure.rawValue
            cardView.count = cardModel.count.rawValue
            cardView.isSelected = selectedCards.contains(cardModel)
            
            cardView.backgroundColor = .clear
            addSubview(cardView)
        }
    }
}
