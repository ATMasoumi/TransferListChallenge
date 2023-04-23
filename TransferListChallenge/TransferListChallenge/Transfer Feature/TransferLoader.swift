//
//  TransferLoader.swift
//  
//
//  Created by Amir Masoumi on 4/19/23.
//

import Foundation

public protocol TransferLoader {
    typealias Result = Swift.Result<[Transfer], Error>

    func load(page:Int ,completion: @escaping (Result) -> Void)
}
