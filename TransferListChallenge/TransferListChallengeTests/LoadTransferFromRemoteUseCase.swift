//
//  LoadTransferFromRemoteUseCase.swift
//  LoadTransferFromRemoteUseCase
//
//  Created by Amir Masoumi on 4/19/23.
//

import XCTest
import TransferListChallenge

public protocol HTTPClient {
    typealias Result = Swift.Result<(Data, HTTPURLResponse),Error>
    func get(from url: URL, completion: @escaping (HTTPClient.Result) -> Void)
}

public protocol TransferLoader {
    typealias Result = Swift.Result<[String], Error>

    func load(completion: @escaping (Result) -> Void)
}

public struct Transfer {
    public let note: String
}

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
        client.get(from: url) { result in
            switch result {
            case .success:
                break
            case .failure:
                completion(.failure(Error.connectivity))
            }
        }
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
        
        sut.load { _ in }
        
        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    func test_loadTwice_requestsDataFromURLTwice() {
        let url = URL(string: "https://a-given-url.com")!
        let (sut, client) = makeSUT(url: url)
        
        sut.load { _ in }
        sut.load { _ in }
        
        XCTAssertEqual(client.requestedURLs, [url, url])
    }
    
    func test_load_deliversErrorOnClientError() {
        let (sut, client) = makeSUT()
        
        let expectedResult = TransferLoader.Result.failure(RemoteTransferLoader.Error.connectivity)
        let exp = expectation(description: "Wait for load completion")

        sut.load { receivedResult in
            switch (receivedResult, expectedResult) {
                
            case let (.failure(receivedError as RemoteTransferLoader.Error), .failure(expectedError as RemoteTransferLoader.Error)):
                XCTAssertEqual(receivedError, expectedError)
                
            default:
                XCTFail("Expected result \(expectedResult) got \(receivedResult) instead")
            }
            
            exp.fulfill()
        }
        
        let clientError = NSError(domain: "Test", code: 0)
        client.complete(with: clientError)
        
        wait(for: [exp], timeout: 1.0)

    }
    
    
    // MARK: - Helpers
    
    private func makeSUT(url: URL = URL(string: "https://a-url.com")!, file: StaticString = #file, line: UInt = #line) -> (sut: RemoteTransferLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteTransferLoader(url: url, client: client)
        return (sut, client)
    }
    
    private class HTTPClientSpy: HTTPClient {
        
        private var messages = [(url: URL,completion: (HTTPClient.Result) -> Void)]()
        
        var requestedURLs: [URL] {
            return messages.map { $0.url }
        }
        
        func get(from url: URL, completion: @escaping (HTTPClient.Result) -> Void) {
            messages.append((url, completion))
        }
        
        func complete(with error: Error, at index: Int = 0) {
            messages[index].completion(.failure(error))
        }
        
        
    }

}
