//
//  HTTPClientResult.swift
//  EssentialFeed
//
//  Created by Hugo Vanderlei on 09/12/24.
//

import Foundation

// MARK: - HTTPClientResult

public enum HTTPClientResult {
    case success(Data, HTTPURLResponse)
    case failure(Error)
}

// MARK: - HTTPClient

public protocol HTTPClient {
    func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void)
}
