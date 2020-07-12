//
//  Card.swift
//  Concentration
//
//  Created by Max Sabadyshyn on 5/1/19.
//  Copyright © 2019 Maksym Sabadyshyn. All rights reserved.
//

import Foundation

struct Card: Hashable {
    var isFaceUp = false
    var isMatched = false
    var hasSeenBefore = false
    private var identifier: Int
    private static var identifierFactory = 0

    init() {
        identifier = Card.getUniqueIdentifier()
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }

    static func == (lhs: Card, rhs: Card) -> Bool {
        return lhs.identifier == rhs.identifier
    }

    private static func getUniqueIdentifier() -> Int {
        identifierFactory += 1
        return identifierFactory
    }
}
