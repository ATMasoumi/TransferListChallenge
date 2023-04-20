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
}

// MARK: - Card
public struct Card: Equatable {
    public let cardNumber, cardType: String
}

// MARK: - MoreInfo
public struct MoreInfo: Equatable {
    public let numberOfTransfers, totalTransfer: Int
}

// MARK: - Person
public struct Person: Equatable {
    public let fullName: String
    public let email: String?
    public let avatar: URL
}
