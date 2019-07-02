//
//  ViewController.swift
//  Concentration
//
//  Created by Max Sabadyshyn on 3/20/19.
//  Copyright © 2019 Maksym Sabadyshyn. All rights reserved.
//

/*
  You can find out what time it is using the Date struct. Read the documentation to figure out how it works and then use it to adjust your scoring so that the more quickly moves are made, the better the user’s score is. You can modify the scoring Required Task in doing this, but the score must still somehow be dependent on matches being rewarded and mismatches of previously-seen cards being penalized (in addition to being time-based). It’s okay if a “good score” is a low number and a “bad score” is a high number.*/

import UIKit

class ViewController: UIViewController {
    lazy var game = Concentration(numberOfPairsOfCards: (cardButtons.count+1)/2)
    
    @IBOutlet weak var flipCountLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    
    @IBOutlet var cardButtons: [UIButton]!
    
    private var levelCount = 1
    private let maxLevel = 6
    private var arrOfUsedEmojis: [String] = ["emojiHalloween"]

    
    override func viewDidLoad() {
          levelLabel.text = "Level: \(levelCount)"
    }
    
    
    @IBAction func touchCard(_ sender: UIButton) {
        if let cardNumber = cardButtons.index(of: sender){
             game.chooseCard(at: cardNumber)
             updateViewFromModel()
            if game.goToNextLevel == true{
                if levelCount<maxLevel{
                    let popUpVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "popUpVCid") as! PopUpViewController // 1
                    
                    self.addChildViewController(popUpVC) // 2
                    popUpVC.view.frame = self.view.frame  // 3
                    self.view.addSubview(popUpVC.view) // 4
                    
                    popUpVC.didMove(toParentViewController: self) // 5
                    
                    transitionToDifferentLevel(level: game.level)
                    levelCount += 1
                    levelLabel.text = "Level: \(levelCount) "
                    
                    game.goToNextLevel = false
                } else{
                    arrOfUsedEmojis.removeAll()
                    newGameButtonPressed(cardButtons[0])
                    let popUpFinish = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "finishedGamePopUp") as! FinishGameViewController // 1
                    
                    self.addChildViewController(popUpFinish) // 2
                    popUpFinish.view.frame = self.view.frame  // 3
                    self.view.addSubview(popUpFinish.view) // 4
                    
                    popUpFinish.didMove(toParentViewController: self) // 5
                    
                    
                }
               
            }
            
        } else{
            print("Wrong card chosen")
        }
    }
    
    //emoji packs
    
    var dictionaryOfThemes: [String:[String]]! =
                            ["emojiHalloween":["👻","🎃", "🍭","😈","🕷","🕸"],
                            "emojiNewYear":["🥂","⛄️","❄️","🌲","🐉","🎅🏻"],
                            "emojiIndependenceDay":["🇺🇸","🇺🇦","🗽","🇺🇳","👮🏻‍♂️","👨🏿‍💼"],
                            "emojiValentinesDay":["💕","🌹","💑","🍷","💋","🥰"],
                            "emojiMashaSamovol": ["👸🏽","😍","❤️","🥇","🍣","🐱"],
                            "emojiStudyingDay":["🤓","🤔","👨🏼‍🏫","🏫","🚌","🎓"]]

    var emoji = [Int:String]()
    
    lazy var currentEmojiThemeName = "emojiHalloween"
    
    var backgroundColor=#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    var cardsColor=#colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)

    
    func updateViewFromModel(){
        flipCountLabel.text = "Flips: \(game.numberOfFlips)"
        scoreLabel.text = "Score: \(game.score)"
        for index in cardButtons.indices{
            let button = cardButtons[index]
            let card = game.cards[index]
            if card.isFaceUp{
                button.setTitle(emoji(for: card), for: UIControlState.normal)
                button.backgroundColor=cardsColor
            } else{
                button.setTitle("", for: UIControlState.normal);
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 0) : cardsColor
            }
        }
      
    }
    
    func emoji(for card: Card)->String{
        
        if emoji[card.identifier]==nil,dictionaryOfThemes[currentEmojiThemeName] != nil,dictionaryOfThemes[currentEmojiThemeName]!.count>0{
            let randomIndex = Int(arc4random_uniform(UInt32(dictionaryOfThemes[currentEmojiThemeName]!.count)))
            emoji[card.identifier]=dictionaryOfThemes[currentEmojiThemeName]!.remove(at: randomIndex)
        }
        return emoji[card.identifier] ?? "?"
    }
    
    @IBAction func newGameButtonPressed(_ sender: UIButton) {
        levelCount = 1
        levelLabel.text = "Level: \(levelCount) "
        game = Concentration(numberOfPairsOfCards: (cardButtons.count+1)/2)
        dictionaryOfThemes =
            ["emojiHalloween":["👻","🎃", "🍭","😈","🕷","🕸"],
             "emojiNewYear":["🥂","⛄️","❄️","🌲","🐉","🎅🏻"],
             "emojiIndependenceDay":["🇺🇸","🇺🇦","🗽","🇺🇳","👮🏻‍♂️","👨🏿‍💼"],
             "emojiValentinesDay":["💕","🌹","💑","🍷","💋","🥰"],
             "emojiMashaSamovol": ["👸🏽","😍","❤️","🥇","🍣","🐱"],
             "emojiStudyingDay":["🤓","🤔","👨🏼‍🏫","🏫","🚌","🎓"]]
        
        //currentEmojiThemeName = //Array(dictionaryOfThemes.keys)[Int(arc4random_uniform(UInt32(Array(dictionaryOfThemes).count)))]
        currentEmojiThemeName = "emojiHalloween"
        initialViewSettings()
        updateViewFromModel()
    }
    
    func transitionToDifferentLevel(level: Int){
        game = Concentration(numberOfPairsOfCards: (cardButtons.count+1)/2)
        dictionaryOfThemes =
            ["emojiHalloween":["👻","🎃", "🍭","😈","🕷","🕸"],
             "emojiNewYear":["🥂","⛄️","❄️","🌲","🐉","🎅🏻"],
             "emojiIndependenceDay":["🇺🇸","🇺🇦","🗽","🇺🇳","👮🏻‍♂️","👨🏿‍💼"],
             "emojiValentinesDay":["💕","🌹","💑","🍷","💋","🥰"],
             "emojiMashaSamovol": ["👸🏽","😍","❤️","🥇","🍣","🐱"],
             "emojiStudyingDay":["🤓","🤔","👨🏼‍🏫","🏫","🚌","🎓"]]
        
      
        while true{
            currentEmojiThemeName = Array(dictionaryOfThemes.keys)[Int(arc4random_uniform(UInt32(Array(dictionaryOfThemes).count)))]
            if !arrOfUsedEmojis.contains(currentEmojiThemeName){
                arrOfUsedEmojis.append(currentEmojiThemeName)
                break
            }
            
       }
      //  currentEmojiThemeName = Array(dictionaryOfThemes.keys)[level-1]
        initialViewSettings()
        updateViewFromModel()
    }
    
    func initialViewSettings(){
        switch currentEmojiThemeName{
        case "emojiNewYear":
            backgroundColor=#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            cardsColor=#colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        case "emojiIndependenceDay":
            backgroundColor=#colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
            cardsColor=#colorLiteral(red: 0.09019608051, green: 0, blue: 0.3019607961, alpha: 1)
        case "emojiValentinesDay":
            backgroundColor=#colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
            cardsColor=#colorLiteral(red: 0.9995340705, green: 0.988355577, blue: 0.4726552367, alpha: 1)
        case "emojiMashaSamovol":
            backgroundColor=#colorLiteral(red: 0.0201725252, green: 0.4219881296, blue: 0.02140678838, alpha: 1)
            cardsColor=#colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        case "emojiStudyingDay":
            backgroundColor=#colorLiteral(red: 1, green: 0.8323456645, blue: 0.4732058644, alpha: 1)
            cardsColor=#colorLiteral(red: 0.4620226622, green: 0.8382837176, blue: 1, alpha: 1)
        default:
            backgroundColor=#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            cardsColor=#colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
            
        }
        view.backgroundColor=backgroundColor
        for index in cardButtons.indices{
            cardButtons[index].backgroundColor = cardsColor
        }
    }
    
}

