//
//  RemoteTransferLoader.swift
//  
//
//  Created by Amir Masoumi on 4/19/23.
//

import Foundation

public final class RemoteTransferLoader: TransferLoader {
    
    private let baseURL: URL
    private let client: HTTPClient

    public enum Error: Swift.Error , Equatable{
        case connectivity
        case invalidData
    }

    typealias Result = TransferLoader.Result
    
    public init(baseURL: URL, client: HTTPClient) {
        self.baseURL = baseURL
        self.client = client
    }
    
    public func load(page: Int, completion: @escaping (TransferLoader.Result) -> Void) {
        
        client.get(from: TransferEndpoint.get.url(baseURL: baseURL, page: page)) { [weak self] result in
            DispatchQueue.main.async {
                guard self != nil else { return }

                switch result {
                case let .success((data, response)):
                    completion(RemoteTransferLoader.map(data, from: response))
                case .failure:
                    completion(.failure(Error.connectivity))
                }
            }
        }
    }
    private static func map(_ data: Data, from response: HTTPURLResponse) -> Result {
        do {
            let items = try TransferItemsMapper.map(data, from: response)
            return .success(items.toModels())
        } catch {
            return .failure(error)
        }
    }

}

private extension Array where Element == RemoteTransferItem {
    func toModels() -> [Transfer] {
        return map { Transfer(person: Person(fullName: $0.person.fullName,
                                             email: $0.person.email,
                                             avatar: URL(string: $0.person.avatar)!
                                            ),
                              card: Card(cardNumber: $0.card.cardNumber,
                                         cardType: $0.card.cardType),
                              lastTransfer: $0.lastTransfer.toDate(),
                              note: $0.note,
                              moreInfo: MoreInfo(numberOfTransfers: $0.moreInfo.numberOfTransfers,
                                                 totalTransfer: $0.moreInfo.totalTransfer), markedFavorite: false)
        }
    }
}

