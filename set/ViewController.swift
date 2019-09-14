//
//  ViewController.swift
//  set
//
//  Created by Roman Zakharov on 14/09/2019.
//  Copyright © 2019 Roman Zakharov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var game = GameSet()
    
    @IBAction func tapNewGame() {
        game = GameSet()
        redrawCards()
    }
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet weak var add3CardsButton: UIButton!
    
    @IBAction func tapAdd3Cards(_ sender: UIButton) {
        game.addThreeCards()
        redrawCards()
    }
    
    @IBOutlet var cardButtons: [UIButton]!
    
    
    @IBAction func tapCard(_ sender: UIButton) {
        game.selectCard(cardButtons.firstIndex(of: sender)!)
        redrawCards()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        redrawCards()
    }
    
    func redrawCards() {
        var counter = 0
        let cardsCount = game.cards.count
        
        for button in cardButtons {
            if counter < cardsCount {
                let card = game.cards[counter]
                var buttonText: String
                
                var isStripped = false
                let strokeStyle: Double
                switch card.style {
                case .filled : strokeStyle = -1
                case .striped : strokeStyle = 0; isStripped = true
                case .outlined : strokeStyle = 10
                }
                
                switch card.figure {
                case .circle : buttonText = isStripped ? "◐" : "⬤"
                case .triangle : buttonText = isStripped ? "◭" : "▲"
                case .square : buttonText = isStripped ? "◧" : "■"
                }
                buttonText = buttonText.repeated(times: card.count.rawValue)
                
                let color: UIColor
                switch card.color {
                case .blue : color = UIColor.blue
                case .green : color = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
                case .red : color = UIColor.red
                }
                
                let attributedString = NSAttributedString(
                    string: buttonText,
                    attributes: [.strokeWidth: strokeStyle,
                                 .foregroundColor: color])
                
                button.setAttributedTitle(attributedString, for: .normal)
                button.isEnabled = true
                button.backgroundColor = #colorLiteral(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393, alpha: 1)
                button.layer.cornerRadius = 8
                
                if game.cardSelection[counter] == true {
                    button.layer.borderWidth = 3.0
                    button.layer.borderColor = UIColor.white.cgColor
                } else {
                    button.layer.borderWidth = 0.0
                }
            } else {
                let attributedString = NSAttributedString(
                    string: "",
                    attributes: [:])
                
                button.setAttributedTitle(attributedString, for: .normal)
                button.isEnabled = false
                button.backgroundColor = #colorLiteral(red: 0.4756349325, green: 0.4756467342, blue: 0.4756404161, alpha: 1)
                button.layer.borderWidth = 0.0
            }
            counter += 1
        }
        
        if game.deck.count < 3 || game.cards.count > 21 {
            add3CardsButton.isHidden = true
        } else {
            add3CardsButton.isHidden = false
        }
        
        scoreLabel.text = "Score: \(game.score)"
    }
}
