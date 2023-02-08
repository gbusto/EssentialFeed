//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by Gabriel Busto on 2/3/23.
//

import Foundation

// Need this to conform to Equatable, but the Error is generic and don't know if passed error will conform to Equatable
public enum LoadFeedResult<Error: Swift.Error> {
    case success([FeedItem])
    case failure(Error)
}

extension LoadFeedResult: Equatable where Error: Equatable {}

protocol FeedLoader {
    associatedtype Error: Swift.Error
    
    func load(completion: @escaping (LoadFeedResult<Error>) -> Void)
}
