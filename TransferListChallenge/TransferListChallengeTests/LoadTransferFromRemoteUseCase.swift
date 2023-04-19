//
//  LoadTransferFromRemoteUseCase.swift
//  LoadTransferFromRemoteUseCase
//
//  Created by Amir Masoumi on 4/19/23.
//

import XCTest
import TransferListChallenge

public protocol HTTPClient {
    func get(from url: URL)
}

public protocol TransferLoader {
    func load()
}

public struct Transfer {
    public let note: String
}

public final class RemoteTransferLoader: TransferLoader {
    private let url: URL
    private let client: HTTPClient


    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    public func load() {
        client.get(from: url)
    }
    
    
}

final class LoadTransferFromRemoteUseCase: XCTestCase {

    func test_init_doesNotRequestDataFromURL() {
        let (_, client) = makeSUT()
        
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    func test_load_requestsDataFromURL() {
        let url = URL(string: "https://a-given-url.com")!
        let (sut, client) = makeSUT(url: url)
        
        sut.load ()
        
        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    
    // MARK: - Helpers
    
    private func makeSUT(url: URL = URL(string: "https://a-url.com")!, file: StaticString = #file, line: UInt = #line) -> (sut: RemoteTransferLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteTransferLoader(url: url, client: client)
        return (sut, client)
    }
    
    private class HTTPClientSpy: HTTPClient {
        
        private var messages = [URL]()
        
        var requestedURLs: [URL] {
            return messages.map { $0 }
        }
        
        func get(from url: URL) {
            messages.append(url)
        }
        
    }

}
