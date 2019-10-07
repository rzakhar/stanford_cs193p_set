//
//  ViewController.swift
//  set
//
//  Created by Roman Zakharov on 14/09/2019.
//  Copyright © 2019 Roman Zakharov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private var game = GameSet()
    
    @IBOutlet private weak var cheatButton: UIButton!
    
    @IBAction func tapCheatButton(_ sender: Any) {
        game.cheat()
        redrawCards()
    }
    
    @IBOutlet private weak var scoreLabel: UILabel!
    
    @IBOutlet private weak var add3CardsButton: UIButton!
    
    @IBAction private func tapAdd3Cards(_ sender: UIButton) {
        game.addThreeCards()
        redrawCards()
    }
    
    @IBOutlet private weak var newGameButton: UIButton!
    
    @IBAction private func tapNewGame() {
        game = GameSet()
        redrawCards()
    }
    
    @objc func tapCard(sender: UITapGestureRecognizer) {
        let cardsCount = game.cards.count

        // TODO: move somewhere
        var grid = Grid(layout: .aspectRatio(8 / 12), frame: boardView.bounds)
        grid.cellCount = cardsCount
        
        let location = sender.location(in: boardView)
        for i in 0..<cardsCount {
            let cardFrame = grid[i]!
            if cardFrame.contains(location) {
                game.selectCard(i)
                redrawCards()
                break
            }
        }
    }
    
    internal override func viewDidLoad() {
        super.viewDidLoad()
        redrawCards()
        for interfaceButton in [add3CardsButton, cheatButton, newGameButton] {
            interfaceButton?.layer.cornerRadius = 8
            interfaceButton?.layer.borderWidth = 0.5
            interfaceButton?.layer.borderColor = UIColor.black.cgColor
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapCard))
        boardView.addGestureRecognizer(tap)
    }
    
    @IBOutlet weak var boardView: UIView!
    
    private func redrawCards() {
        let cardsCount = game.cards.count
        
        // TODO: move somewhere
        var grid = Grid(layout: .aspectRatio(2 / 3), frame: boardView.bounds)
        grid.cellCount = cardsCount
        
        for subView in boardView.subviews {
            subView.removeFromSuperview()
        }
        
        for i in 0..<cardsCount {
            let cardFrame = grid[i]!
            
            let card = CardView(frame: cardFrame)
            let cardModel = game.cards[i]
            card.color = cardModel.color.rawValue
            card.style = cardModel.style.rawValue
            card.figure = cardModel.figure.rawValue
            card.count = cardModel.count.rawValue
            card.backgroundColor = .clear
            card.isOpaque = false
            card.isSelected = game.selectedCards.contains(cardModel)
            boardView.addSubview(card)
        }

        add3CardsButton.isHidden = (game.deck.count < 3)

        scoreLabel.text = "Score: \(game.score)"
    }
}
