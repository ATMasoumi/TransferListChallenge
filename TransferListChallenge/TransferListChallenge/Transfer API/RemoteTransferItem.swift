//
//  RemoteTransferItem.swift
//  TransferListChallenge
//
//  Created by Amir Masoumi on 4/19/23.
//

import Foundation


// MARK: - Transfer
struct RemoteTransferItem: Codable {
    let person: RemotePerson
    let card: RemoteCard
    let lastTransfer: String
    let note: String?
    let moreInfo: RemoteMoreInfo

    enum CodingKeys: String, CodingKey {
        case person, card
        case lastTransfer = "last_transfer"
        case note
        case moreInfo = "more_info"
    }
}

// MARK: - Card
struct RemoteCard: Codable {
    let cardNumber, cardType: String

    enum CodingKeys: String, CodingKey {
        case cardNumber = "card_number"
        case cardType = "card_type"
    }
}

// MARK: - MoreInfo
struct RemoteMoreInfo: Codable {
    let numberOfTransfers, totalTransfer: Int

    enum CodingKeys: String, CodingKey {
        case numberOfTransfers = "number_of_transfers"
        case totalTransfer = "total_transfer"
    }
}

// MARK: - Person
struct RemotePerson: Codable {
    let fullName: String
    let avatar: String
    let email: String?

    enum CodingKeys: String, CodingKey {
        case fullName = "full_name"
        case email, avatar
    }
}
