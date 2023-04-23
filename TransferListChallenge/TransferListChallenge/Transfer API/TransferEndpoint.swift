//
//  TransferEndpoint.swift
//  TransferListChallenge
//
//  Created by Amir Masoumi on 4/23/23.
//

import Foundation

public enum TransferEndpoint {
    case get
    
    public func url(baseURL: URL, page: Int) -> URL {
        switch self {
        case .get:
            var components = URLComponents()
            components.scheme = baseURL.scheme
            components.host = baseURL.host
            components.path = baseURL.path + "/transfer-list/\(page)"
            return components.url!
        }
    }
}
