//
//  TransferItemsMapper.swift
//  TransferListChallenge
//
//  Created by Amir Masoumi on 4/19/23.
//

import Foundation

final class FeedItemsMapper {
   
    static func map(_ data: Data, from response: HTTPURLResponse) throws -> [RemoteTransferItem] {
        guard response.isOK, let root = try? JSONDecoder().decode([RemoteTransferItem].self, from: data) else {
            throw RemoteTransferLoader.Error.invalidData
        }

        return root
    }
}
