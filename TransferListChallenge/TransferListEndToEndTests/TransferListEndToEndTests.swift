//
//  TransferListEndToEndTests.swift
//  TransferListEndToEndTests
//
//  Created by Amir Masoumi on 4/20/23.
//

import XCTest
import TransferListChallenge

final class TransferListEndToEndTests: XCTestCase {

    
    func test_getTransferResult() {
        let result = getTransferResult()
        XCTAssertEqual(try result?.get().count, 10)
    }
    
    private func getTransferResult() -> TransferLoader.Result? {
        let baseURL = URL(string: "https://4e6774cc-4d63-41b2-8003-336545c0a86d.mock.pstmn.io")!
        let client = URLSessionHTTPClient()
        let loader = RemoteTransferLoader(baseURL: baseURL, client: client)
        
        let exp = expectation(description: "Wait for load completion")
        
        var receivedResult: TransferLoader.Result?
        loader.load(page: 1) { result in
            receivedResult = result
            exp.fulfill()
        }
        wait(for: [exp], timeout: 10.0)
        
        return receivedResult
    }
}
