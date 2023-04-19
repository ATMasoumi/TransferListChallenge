//
//  HTTPClient.swift
//  
//
//  Created by Amir Masoumi on 4/19/23.
//

import Foundation

public protocol HTTPClient {
    typealias Result = Swift.Result<(Data, HTTPURLResponse),Error>
    func get(from url: URL, completion: @escaping (HTTPClient.Result) -> Void)
}
