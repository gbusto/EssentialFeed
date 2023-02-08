//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by Gabriel Busto on 2/3/23.
//

import Foundation

// Need this to conform to Equatable, but the Error is generic and don't know if passed error will conform to Equatable
public enum LoadFeedResult {
    case success([FeedItem])
    case failure(Error)
}

protocol FeedLoader {
    func load(completion: @escaping (LoadFeedResult) -> Void)
}
