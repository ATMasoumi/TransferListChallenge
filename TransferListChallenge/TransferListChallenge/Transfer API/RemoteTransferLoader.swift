//
//  RemoteTransferLoader.swift
//  
//
//  Created by Amir Masoumi on 4/19/23.
//

import Foundation

public final class RemoteTransferLoader: TransferLoader {
    
    private let url: URL
    private let client: HTTPClient

    public enum Error: Swift.Error , Equatable{
        case connectivity
        case invalidData
    }

    typealias Result = TransferLoader.Result
    
    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    public func load(completion: @escaping (TransferLoader.Result) -> Void) {
        client.get(from: url) { [weak self] result in
            guard self != nil else { return }

            switch result {
            case let .success((data, response)):
                completion(RemoteTransferLoader.map(data, from: response))
            case .failure:
                completion(.failure(Error.connectivity))
            }
        }
    }
    private static func map(_ data: Data, from response: HTTPURLResponse) -> Result {
        do {
            let items = try FeedItemsMapper.map(data, from: response)
            return .success(items.toModels())
        } catch {
            return .failure(error)
        }
    }

}

private extension Array where Element == RemoteTransferItem {
    func toModels() -> [Transfer] {
        return map { Transfer(note: $0.note) }
    }
}

private struct Root: Decodable {
    let items: [Item]
}

private struct Item: Decodable {
    let note: String
    
    var item: Transfer {
        return Transfer(note: note)
    }
}
