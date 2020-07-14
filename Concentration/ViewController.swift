//
//  ViewController.swift
//  Concentration
//
//  Created by Max Sabadyshyn on 3/20/19.
//  Copyright © 2019 Maksym Sabadyshyn. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    lazy var game = Concentration(numberOfPairsOfCards: (cardButtons.count + 1) / 2)
    
    @IBOutlet weak var flipCountLabel: UILabel! {
        didSet {
            setFlipsLabel() 
        }
    }

    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    
    @IBOutlet var cardButtons: [UIButton]!
    
    private var levelCount = 1
    private let maxLevel = 6
    
    var emoji = [Card:String]()

    var emojiThemes = [
        Theme(name: "emojiHalloween", emojiPackage: ["👻","🎃", "🍭","😈","🕷","🕸"], backgroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), cardColor: #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)),
        Theme(name: "emojiNewYear", emojiPackage: ["🥂","⛄️","❄️","🌲","🐉","🎅🏻"], backgroundColor: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), cardColor: #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)),
        Theme(name: "emojiIndependenceDay", emojiPackage: ["🇺🇸","🇺🇦","🗽","🇺🇳","👮🏻‍♂️","👨🏿‍💼"], backgroundColor: #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1), cardColor: #colorLiteral(red: 0.09019608051, green: 0, blue: 0.3019607961, alpha: 1)),
        Theme(name: "emojiValentinesDay", emojiPackage: ["💕","🌹","💑","🍷","💋","🥰"], backgroundColor: #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1), cardColor: #colorLiteral(red: 0.9995340705, green: 0.988355577, blue: 0.4726552367, alpha: 1)),
        Theme(name: "emojiMashaSamovol", emojiPackage: ["👸🏽","😍","❤️","🥇","🍣","🐱"], backgroundColor: #colorLiteral(red: 0.0201725252, green: 0.4219881296, blue: 0.02140678838, alpha: 1), cardColor: #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)),
        Theme(name: "emojiStudyingDaн", emojiPackage: ["🤓","🤔","👨🏼‍🏫","🏫","🚌","🎓"], backgroundColor: #colorLiteral(red: 1, green: 0.8323456645, blue: 0.4732058644, alpha: 1), cardColor: #colorLiteral(red: 0.4620226622, green: 0.8382837176, blue: 1, alpha: 1))]

    lazy var currentEmojiTheme = emojiThemes.first

    override func viewDidLoad() {
        levelLabel.text = "Level: \(levelCount)"
    }
    
    
    @IBAction func touchCard(_ sender: UIButton) {
        if let cardNumber = cardButtons.index(of: sender) {
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
            if game.goToNextLevel == true {
                if levelCount < maxLevel {
                    let popUpVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "popUpVCid") as! PopUpViewController
                    
                    self.addChildViewController(popUpVC)
                    popUpVC.view.frame = self.view.frame
                    self.view.addSubview(popUpVC.view)
                    
                    popUpVC.didMove(toParentViewController: self)
                    levelCount += 1
                    transitionToDifferentLevel(level: levelCount)
                    levelLabel.text = "Level: \(levelCount) "
                    
                    game.goToNextLevel = false

                } else {
                    newGameButtonPressed(cardButtons[0])
                    let popUpFinish = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "finishedGamePopUp") as! FinishGameViewController
                    
                    self.addChildViewController(popUpFinish)
                    popUpFinish.view.frame = self.view.frame
                    self.view.addSubview(popUpFinish.view)
                    
                    popUpFinish.didMove(toParentViewController: self)
                }
            }
            
        } else {
            print("Wrong card chosen")
        }
    }

    func setFlipsLabel() {
        let attributes: [NSAttributedStringKey: Any] = [
            .strokeWidth : 5.0,
            .strokeColor : UIColor.orange
        ]

        let flipsCounts = NSAttributedString(string: "Flips: \(game.numberOfFlips)", attributes: attributes)
        flipCountLabel.attributedText = flipsCounts
    }
    
    func updateViewFromModel() {

        guard let currentEmojiTheme = currentEmojiTheme else {
            return
        }

        setFlipsLabel()
        scoreLabel.text = "Score: \(game.score)"

        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            if card.isFaceUp {
                button.setTitle(emoji(for: card), for: UIControlState.normal)
                button.backgroundColor = currentEmojiTheme.backgroundColor
            } else {
                button.setTitle("", for: UIControlState.normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 0) : currentEmojiTheme.cardColor
            }
        }
    }
    
    func emoji(for card: Card) -> String {
        
        guard emoji[card] == nil && currentEmojiTheme?.emojiPackage != nil else {
            return emoji[card]!
        }
            
        let randomIndex = Int(arc4random_uniform(UInt32(currentEmojiTheme!.emojiPackage.count)))

        emoji[card] = currentEmojiTheme!.emojiPackage.remove(at: randomIndex)

        return emoji[card] ?? "?"
    }
    
    @IBAction func newGameButtonPressed(_ sender: UIButton) {
        levelCount = 1
        levelLabel.text = "Level: \(levelCount) "
        game = Concentration(numberOfPairsOfCards: (cardButtons.count + 1) / 2)
        initialViewSettings()
        updateViewFromModel()
    }
    
    func transitionToDifferentLevel(level: Int) {
        game = Concentration(numberOfPairsOfCards: (cardButtons.count + 1) / 2)
        currentEmojiTheme = emojiThemes[level-1]
        initialViewSettings()
        updateViewFromModel()
    }
    
    func initialViewSettings() {

        guard let currentEmojiTheme = currentEmojiTheme else {
            return
        }

        view.backgroundColor = currentEmojiTheme.backgroundColor

        for index in cardButtons.indices {
            cardButtons[index].backgroundColor = currentEmojiTheme.cardColor
        }
    }
}

