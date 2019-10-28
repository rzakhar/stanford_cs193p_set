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

    @IBOutlet private weak var add3CardsButton: UIButton!

    @IBAction private func tapAdd3Cards(_ sender: UIButton) {
        if game.deck.count >= 3 {
            game.addThreeCards()
            redrawScreen()
        }
    }

    @IBOutlet private weak var newGameButton: UIButton!

    @IBAction private func tapNewGame() {
        game = GameSet()
        redrawScreen()
    }

    @IBOutlet private weak var boardView: BoardView!

    @objc private func tapCard(sender: UITapGestureRecognizer) {
        let cardsCount = game.cards.count

        let location = sender.location(in: boardView)
        for index in 0..<cardsCount {
            let cardFrame = boardView.grid[index]!
            if cardFrame.contains(location) {
                game.selectCard(index)
                redrawScreen()
                break
            }
        }
    }

    @objc private func swipeBoard(sender: UISwipeGestureRecognizer) {
        tapAdd3Cards(newGameButton)
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
        for interfaceButton in [add3CardsButton, cheatButton, newGameButton] {
            interfaceButton?.layer.cornerRadius = 8
            interfaceButton?.layer.borderWidth = 0.5
            interfaceButton?.layer.borderColor = UIColor.black.cgColor
        }

        let tap = UITapGestureRecognizer(target: self, action: #selector(tapCard))
        boardView.addGestureRecognizer(tap)

        let verticalSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeBoard))
        verticalSwipe.direction = [.down, .up]
        boardView.addGestureRecognizer(verticalSwipe)

        let horizontalSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeBoard))
        horizontalSwipe.direction = [.left, .right]
        boardView.addGestureRecognizer(horizontalSwipe)

        let rotation = UIRotationGestureRecognizer(target: self, action: #selector(rotationBoard))
        boardView.addGestureRecognizer(rotation)

        redrawScreen()
    }

    private func redrawScreen() {
        boardView.redrawCards(cards: game.cards, selectedCards: game.selectedCards)
        add3CardsButton.isHidden = game.deck.count == 0
        cheatButton.isHidden = game.deck.count == 0 && game.possibleSet.isEmpty
        scoreLabel.text = "Score: \(game.score)"
    }
}