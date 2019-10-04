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
    private var possibleSet = [Card]()
    private(set) var deck = [Card]()
    private(set) var score = 0
    
    func selectCard(_ index: Int) {
        assert((0..<cards.count).contains(index), "Incorrect index of card.")

        if selectedCards.contains(cards[index]) {
            selectedCards.removeAll(where: { $0 == cards[index] } )
        } else {
            selectedCards.append(cards[index])
        }
        if selectedCards.count == 3 {
            if cardsMakeSet(selectedCards) {
                score += 10
                for card in selectedCards {
                    if deck.count > 0 {
                        replaceCard(card)
                    } else {
                        deleteCard(card)
                    }
                }
                findPossibleSet()
            } else {
                score -= 10
            }
            selectedCards = []
        }
    }
    
    func cheat() {
        score -= 9
        if possibleSet.count == 3 {
            selectedCards = possibleSet
            selectedCards.remove(at: [0, 1, 2].randomElement()!)
        } else {
            if deck.count >= 3 {
                addThreeCards()
            }
        }
    }
    
    private func cardsMakeSet(_ cards: [Card]) -> Bool {
        let types = cards.map { $0.figure }
        let counts = cards.map { $0.count }
        let colors = cards.map { $0.color }
        let styles = cards.map { $0.style }
        
        return types.allElementsEqualOrUnique &&
                counts.allElementsEqualOrUnique &&
                colors.allElementsEqualOrUnique &&
                styles.allElementsEqualOrUnique
    }
    
    private func findPossibleSet() {
        for i in cards.indices {
            for j in cards.indices {
                for k in cards.indices {
                    if i < j, j < k {
                        let setCandidate = [cards[i], cards[j], cards[k]]
                        if cardsMakeSet(setCandidate) {
                            possibleSet = setCandidate
                            
                            return
                        }
                    }
                }
            }
        }
        possibleSet = []
    }
    
    private func replaceCard(_ card: Card) {
        let cardIndex = getCardIndex(card)
        cards[cardIndex] = deck.remove(at: 0)
    }
    
    private func deleteCard(_ card: Card) {
        let cardIndex = getCardIndex(card)
        cards.remove(at: cardIndex)
    }
    
    private func getCardIndex(_ card: Card) -> Int {
        guard let cardIndex = cards.firstIndex(of: card) else {
            assertionFailure("The card is not on the table.")
            
            return 0
        }
        return cardIndex
    }
    
    func addThreeCards() {
        if possibleSet.count > 0 {
            score -= 50
        }
        openNewCards(count: 3)
    }
    
    private func openNewCards(count: Int) {
        assert(deck.count >= count, "Deck is empty.")
        for _ in 0..<count {
            cards.append(deck.removeFirst())
        }
        findPossibleSet()
    }
    
    init() {
        for figure in Card.FigureType.allCases {
            for count in Card.FigureCount.allCases {
                for style in Card.FigureStyle.allCases {
                    for color in Card.FigureColor.allCases {
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
