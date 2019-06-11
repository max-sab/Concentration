//
//  Card.swift
//  Concentration
//
//  Created by Max Sabadyshyn on 5/1/19.
//  Copyright © 2019 Maksym Sabadyshyn. All rights reserved.
//

import Foundation

struct Card{
    var isFaceUp = false
    var isMatched = false
    var hasSeenBefore = false
    var identifier: Int
    
    private static var identifierFactory = 0
    private static func getUniqueIdentifier()->Int{
        identifierFactory+=1
        return identifierFactory
    }
    
    init(){
        identifier = Card.getUniqueIdentifier()
    }
}
