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
    
    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    public func load(completion: @escaping (TransferLoader.Result) -> Void) {
        client.get(from: url) { [weak self] result in
            guard self != nil else { return }

            switch result {
            case let .success(data, response):
                if response.statusCode == 200, let root = try? JSONDecoder().decode(Root.self, from: data) {
                    completion(.success(root.items.map { $0.item }))
                } else {
                    completion(.failure(Error.invalidData))
                }
            case .failure:
                completion(.failure(Error.connectivity))
            }
        }
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
