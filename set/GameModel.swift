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
    private(set) var selectedCards = [Card]()
    private(set) var deck = [Card]()
    private(set) var score = 0
    
    func selectCard(_ index: Int) {
        if selectedCards.contains(cards[index]) {
            selectedCards.removeAll(where: { $0 == cards[index] } )
        } else {
            selectedCards.append(cards[index])
        }
        if selectedCards.count == 3 {
            let types = selectedCards.map { $0.figure }
            let counts = selectedCards.map { $0.count }
            let colors = selectedCards.map { $0.color }
            let styles = selectedCards.map { $0.style }

            if types.allElementsEqualOrUnique,
                counts.allElementsEqualOrUnique,
                colors.allElementsEqualOrUnique,
                styles.allElementsEqualOrUnique {
                score += 10
                for card in selectedCards {
                    if deck.count > 0 {
                        replaceCard(card)
                    } else {
                        deleteCard(card)
                    }
                }
            } else {
                score -= 10
            }
            selectedCards = []
        }
    }
    
    private func replaceCard(_ card: Card) {
        cards = cards.map { c -> Card in
            if c == card {
                
                return deck.remove(at: 0)
            } else {
                return c
            }
        }
    }
    
    private func deleteCard(_ card: Card) {
        cards.removeAll(where: { $0 == card } )
    }
    
    func addThreeCards() {
        openNewCards(count: 3)
    }
    
    private func openNewCards(count: Int) {
        assert(deck.count >= count, "Deck is empty")
        for _ in 0..<count {
            cards.append(deck.removeFirst())
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
        deck.shuffle()
        openNewCards(count: 12)
    }
}
