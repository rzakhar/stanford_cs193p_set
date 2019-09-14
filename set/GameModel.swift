//
//  GameModel.swift
//  set
//
//  Created by Roman Zakharov on 14/09/2019.
//  Copyright © 2019 Roman Zakharov. All rights reserved.
//

import Foundation

class GameSet {
    
    private(set) var cards = [Card]()
    private(set) var cardSelection = [Bool]()
    private(set) var deck = [Card]()
    private(set) var score = 0
    
    func selectCard(_ index: Int) {
        cardSelection[index].toggle()
        print(index)
        print(cards[index])
        let selectedCardsIndices = cardSelection.indices.filter( { cardSelection[$0] } )
        if selectedCardsIndices.count == 3 {
            let selectedCards = selectedCardsIndices.map { cards[$0] }
            let types = selectedCards.map { $0.figure }
            let counts = selectedCards.map { $0.count }
            let colors = selectedCards.map { $0.color }
            let styles = selectedCards.map { $0.style }
            
            if types.allElementsEqualOrUnique,
                counts.allElementsEqualOrUnique,
                colors.allElementsEqualOrUnique,
                styles.allElementsEqualOrUnique {
                score += 10
                for i in selectedCardsIndices.reversed() {
                    if deck.count > 0 {
                        cards[i] = deck.remove(at: 0)
                        cardSelection[i] = false
                    } else {
                        deleteCard(i)
                    }
                }
            } else {
                score -= 10
                cardSelection = cardSelection.map { _ in false }
            }
        }
    }
    
    private func deleteCard(_ index: Int) {
        cards.remove(at: index)
        cardSelection.remove(at: index)
    }
    
    func addThreeCards() {
        openNewCards(count: 3)
    }
    
    private func openNewCards(count: Int) {
        assert(deck.count >= count, "Deck is empty")
        for _ in 0..<count {
            cards.append(deck.removeFirst())
            cardSelection.append(false)
        }
    }
    
    init() {
        for figure in FigureType.allCases {
            for count in FigureCount.allCases {
                for style in FigureStyle.allCases {
                    for color in FigureColor.allCases {
                        deck.append(Card(figure: figure,
                                          count: count,
                                          style: style,
                                          color: color))
                    }
                }
            }
        }
        //deck.shuffle()
        openNewCards(count: 12)
    }
}
