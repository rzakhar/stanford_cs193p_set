//
//  ViewController.swift
//  set
//
//  Created by Roman Zakharov on 14/09/2019.
//  Copyright © 2019 Roman Zakharov. All rights reserved.
//

import UIKit

class SetViewController: UIViewController {

    private var game = GameSet()

    @IBOutlet private weak var cheatButton: UIButton!

    @IBAction private func tapCheatButton(_ sender: Any) {
        game.cheat()
        redrawScreen()
    }

    @IBOutlet private weak var scoreLabel: UILabel!

    private func deal3Cards() {
        game.addThreeCards()
        redrawScreen()
    }

    @IBOutlet private weak var newGameButton: UIButton!

    @IBAction private func tapNewGame() {
        for subview in boardView.subviews {
            subview.removeFromSuperview()
        }
        game = GameSet()
        displayedCards = game.cards + game.deck
        for card in displayedCards {
            let cardView = CardView(frame: .zero)
             cardView.color = card.color.rawValue
             cardView.style = card.style.rawValue
             cardView.figure = card.figure.rawValue
             cardView.count = card.count.rawValue
            cardView.isFaceUp = false
            cardView.backgroundColor = .clear
            boardView.addSubview(cardView)
        }

        redrawScreen()
    }

    @IBOutlet private weak var boardView: UIView!

    lazy private(set) var grid = Grid(layout: .aspectRatio(2 / 3), frame: boardView.bounds)

    internal override func viewDidLayoutSubviews() {
        view.layoutSubviews()
        grid.frame = boardView.bounds

        redrawCards()
    }

    private var displayedCards: [Card] = []

    func redrawCards() {
        let cards = game.cards
        let selectedCards = game.selectedCards
        let cardsCount = cards.count

        grid.cellCount = cardsCount + 1

        var counter = displayedCards.count - 1
        for card in displayedCards.reversed() {
            let cardView = boardView.subviews[counter] as! CardView
            if game.deck.contains(card) {
                let cardFrame = grid[0]!
                let animator = UIViewPropertyAnimator(duration: 0.5, curve: .easeOut){
                    cardView.frame = cardFrame
                }

                animator.startAnimation()
                cardView.isSelected = selectedCards.contains(card)
                cardView.isFaceUp = false
            } else if let index = game.cards.firstIndex(of: card) {
                let cardFrame = grid[index + 1]!
                let animator = UIViewPropertyAnimator(duration: 0.5, curve: .easeOut){
                    cardView.frame = cardFrame
                }

                animator.startAnimation()
                cardView.isSelected = selectedCards.contains(card)
                cardView.isFaceUp = true
            } else {
                displayedCards.remove(at: counter)
                cardView.removeFromSuperview()
            }
            counter -= 1
        }
    }

    @objc private func tapCard(sender: UITapGestureRecognizer) {
        let location = sender.location(in: boardView)
        for gridCellIndex in 0..<grid.cellCount {
            let cardFrame = grid[gridCellIndex]!
            if cardFrame.contains(location) {
                if gridCellIndex == 0 {
                    if !game.deck.isEmpty {
                        deal3Cards()
                    }
                } else {
                    game.selectCard(gridCellIndex - 1)
                    redrawScreen()
                }
                break
            }
        }
    }

    @objc private func rotationBoard(sender: UIRotationGestureRecognizer) {
        if abs(sender.rotation) > (CGFloat.pi / 4) {
            game.shuffleCards()
            redrawScreen()
            sender.rotation = 0
        }
    }

    internal override func viewDidLoad() {
        super.viewDidLoad()
        for interfaceButton in [cheatButton, newGameButton] {
            interfaceButton?.layer.cornerRadius = 8
            interfaceButton?.layer.borderWidth = 0.5
            interfaceButton?.layer.borderColor = UIColor.black.cgColor
        }

        let tap = UITapGestureRecognizer(target: self, action: #selector(tapCard))
        boardView.addGestureRecognizer(tap)

        let rotation = UIRotationGestureRecognizer(target: self, action: #selector(rotationBoard))
        boardView.addGestureRecognizer(rotation)

        tapNewGame()
    }

    private func redrawScreen() {
        redrawCards()
        cheatButton.isHidden = game.deck.count == 0 && game.possibleSet.isEmpty
        scoreLabel.text = "Score: \(game.score)"
    }
}
