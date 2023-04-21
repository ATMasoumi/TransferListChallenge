//
//  LocalTransfer.swift
//  TransferListChallenge
//
//  Created by Amir Masoumi on 4/20/23.
//

import Foundation

// MARK: - Transfer
public struct LocalTransfer: Equatable {
    public let person: LocalPerson
    public let card: LocalCard
    public let lastTransfer: Date
    public let note: String?
    public let moreInfo: LocalMoreInfo
    public let identifier: String
    public init(person: LocalPerson, card: LocalCard, lastTransfer: Date, note: String?, moreInfo: LocalMoreInfo, identifier: String = UUID().uuidString) {
        self.person = person
        self.card = card
        self.lastTransfer = lastTransfer
        self.note = note
        self.moreInfo = moreInfo
        self.identifier = identifier
    }
}

// MARK: - Card
public struct LocalCard: Equatable {
    public let cardNumber, cardType: String
    public init(cardNumber: String, cardType: String) {
        self.cardNumber = cardNumber
        self.cardType = cardType
    }
}

// MARK: - MoreInfo
public struct LocalMoreInfo: Equatable {
    public let numberOfTransfers, totalTransfer: Int
    public init(numberOfTransfers: Int, totalTransfer: Int) {
        self.numberOfTransfers = numberOfTransfers
        self.totalTransfer = totalTransfer
    }
}

// MARK: - Person
public struct LocalPerson: Equatable {
    public let fullName: String
    public let email: String?
    public let avatar: URL
    public init(fullName: String, email: String?, avatar: URL) {
        self.fullName = fullName
        self.email = email
        self.avatar = avatar
    }
}
