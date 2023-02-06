//
//  RemoteFeedLoader.swift
//  
//
//  Created by Gabriel Busto on 2/3/23.
//

import Foundation

public protocol HTTPClient {
    func get(from url: URL, completion: @escaping (Error?, HTTPURLResponse?) -> Void)
}

public final class RemoteFeedLoader {
    private let url: URL
    private let client: HTTPClient
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    public func load(completion: @escaping (Error) -> Void) {
        client.get(from: url) { error, response in
            if response != nil {
                completion(.invalidData)
            }
            else {
                // If this completion is moved outside of the 'else' statement,
                // one of the tests will fail because load will have called the
                // completion twice with two different errors!
                completion(.connectivity)
            }
        }
    }
}
