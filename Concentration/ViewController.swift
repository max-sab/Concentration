//
//  ViewController.swift
//  Concentration
//
//  Created by Max Sabadyshyn on 3/20/19.
//  Copyright © 2019 Maksym Sabadyshyn. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    lazy var game = Concetration(numberOfPairsOfCards: (cardButtons.count+1)/2)
    var flipCount: Int = 0{
        didSet{
            flipCountLabel.text = "Flips: \(flipCount)"
        }
    }
    
    
    @IBOutlet weak var flipCountLabel: UILabel!
    
    @IBOutlet var cardButtons: [UIButton]!
    
    @IBAction func touchCard(_ sender: UIButton) {
        if let cardNumber = cardButtons.index(of: sender){
             flipCount+=1
             game.chooseCard(at: cardNumber)
             updateViewFromModel()
        } else{
            print("Wrong card chosen")
        }
    }
    
    func updateViewFromModel(){
        for index in cardButtons.indices{
            let button = cardButtons[index]
            let card = game.cards[index]
            if card.isFaceUp{
                button.setTitle(emoji(for: card), for: UIControlState.normal)
                button.backgroundColor=#colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
            } else{
                button.setTitle("", for: UIControlState.normal);
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 0) : #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
            }
        }
      
    }
    
    var emojiChoices = ["👻","🎃", "🍭","😈","🕷","🕸"]
    
    var emoji = [Int:String]()
    
    func emoji(for card: Card)->String{
        if emoji[card.identifier]==nil, emojiChoices.count>0{
            let randomIndex = Int(arc4random_uniform(UInt32(emojiChoices.count)))
            emoji[card.identifier]=emojiChoices.remove(at: randomIndex)
        }
        return emoji[card.identifier] ?? "?"
    }
}
