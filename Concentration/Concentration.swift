//
//  Concentration.swift
//  Concentration
//
//  Created by Max Sabadyshyn on 5/1/19.
//  Copyright © 2019 Maksym Sabadyshyn. All rights reserved.
//

import Foundation

class Concetration{
    private(set) var cards =  [Card]()////////////////
    public var numberOfFlips = 0
    public var score = 0
    private var indexOfOnlyFacedUpCard: Int?{
        get{
            var onlyOneCardFacedUp: Int?
            for index in cards.indices{
                if cards[index].isFaceUp{
                    if onlyOneCardFacedUp==nil{
                        onlyOneCardFacedUp=index
                    } else{
                        return nil
                    }
                }
               
            }
            return onlyOneCardFacedUp
        }
        
        set{
            for index in cards.indices{
                cards[index].isFaceUp = (index==newValue)
            }
        }
    }
    
    func chooseCard(at index: Int){
        assert(cards.indices.contains(index), "Concentration.chooseCard(at:\(index): no index like that in cards!")
        //changing Flips number but checking if card is aplicable
        if cards[index].isMatched==false, cards[index].isFaceUp==false{
           numberOfFlips+=1
        }
        //if card hasn't been matched...
        if !cards[index].isMatched{
            //if there is one and only one faced up card and it's not the one we just opened...
            if let matchedIndex = indexOfOnlyFacedUpCard, index != matchedIndex{
                //if its identifier equals to identifier of previously faced up card...
                if cards[index].identifier == cards[matchedIndex].identifier{
                    //Bingo!
                    cards[index].isMatched=true
                    cards[matchedIndex].isMatched=true
                    score+=3
                }
                //comes here either if cards were matched or if those chosen cards were unmatched
                
                //decreasing score if card was seen before and unmatched
                if (cards[index].hasSeenBefore && !cards[index].isMatched){
                    score = score - 1
                }
                cards[index].isFaceUp=true
                cards[index].hasSeenBefore=true
                
            //if there were no faced up cards or if we matched two earlier and they still on the screen
            } else{
                indexOfOnlyFacedUpCard = index
            }
        }
    }
    
    init(numberOfPairsOfCards:Int){
           assert(numberOfPairsOfCards>0, "init(numberOfPairsOfCards:\(numberOfPairsOfCards): number should be larger than zero!")
        for _ in 1...numberOfPairsOfCards{
            let card = Card()
            cards+=[card,card]
        }
        
        //shuffle cards using Fisher-Yates algorithm
        for index in cards.indices{
            let randomIndex = Int(arc4random_uniform(UInt32(cards.count - index)))
            let tempCard = cards[index]
            cards[index]=cards[randomIndex]
            cards[randomIndex]=tempCard
        }
        //cards.shuffle()
    }
}
