//
//  HTTPURLResponse+StatusCode.swift
//  TransferListChallenge
//
//  Created by Amir Masoumi on 4/19/23.
//

import Foundation

extension HTTPURLResponse {
    private static var OK_200: Int { return 200 }

    var isOK: Bool {
        return statusCode == HTTPURLResponse.OK_200
    }
}
