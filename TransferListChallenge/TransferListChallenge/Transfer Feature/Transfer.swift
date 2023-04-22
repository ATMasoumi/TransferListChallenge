//
//  Transfer.swift
//  
//
//  Created by Amir Masoumi on 4/19/23.
//

import Foundation

// MARK: - Transfer
public struct Transfer: Equatable {
    public let person: Person
    public let card: Card
    public let lastTransfer: Date
    public let note: String?
    public let moreInfo: MoreInfo
    public var markedFavorite: Bool
    public init(person: Person, card: Card, lastTransfer: Date, note: String?, moreInfo: MoreInfo, markedFavorite: Bool) {
        self.person = person
        self.card = card
        self.lastTransfer = lastTransfer
        self.note = note
        self.moreInfo = moreInfo
        self.markedFavorite = markedFavorite
    }
}

// MARK: - Card
public struct Card: Equatable {
    public let cardNumber, cardType: String
    public init(cardNumber: String, cardType: String) {
        self.cardNumber = cardNumber
        self.cardType = cardType
    }
}

// MARK: - MoreInfo
public struct MoreInfo: Equatable {
    public let numberOfTransfers, totalTransfer: Int
    public init(numberOfTransfers: Int, totalTransfer: Int) {
        self.numberOfTransfers = numberOfTransfers
        self.totalTransfer = totalTransfer
    }
}

// MARK: - Person
public struct Person: Equatable {
    public let fullName: String
    public let email: String?
    public let avatar: URL
    public init(fullName: String, email: String?, avatar: URL) {
        self.fullName = fullName
        self.email = email
        self.avatar = avatar
    }
}
