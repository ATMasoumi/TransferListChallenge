//
//  TransferEndPointTests.swift
//  TransferListChallengeTests
//
//  Created by Amir Masoumi on 4/23/23.
//

import XCTest
import TransferListChallenge

final class TransferEndPointTests: XCTestCase {

    func test_transfer_endPointURL() {
        let baseURL = URL(string: "https://4e6774cc-4d63-41b2-8003-336545c0a86d.mock.pstmn.io")!
        let page = 2
        let received = TransferEndpoint.get.url(baseURL: baseURL, page: page)
        
        XCTAssertEqual(received.scheme, "https", "scheme")
        XCTAssertEqual(received.host, "4e6774cc-4d63-41b2-8003-336545c0a86d.mock.pstmn.io", "host")
        XCTAssertEqual(received.path, "/transfer-list/\(page)", "path")

    }

}
