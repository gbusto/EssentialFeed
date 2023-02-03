//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by Gabriel Busto on 2/3/23.
//

import Foundation

/*
 Starting from abstractions bears risk. Example: over-abstracting to accommodate future needs (that may never happen)
 can unnecessarily damage/complicate the current design.
 
 In the Error case below, we don't know (or need to know yet) all errors this feature may have to handle. So stick with
 generic Error for now.
 
 Good design is rarely achieved in the first iteration, as it's an evolutionary process.
 */

enum LoadFeedResult {
    case success([FeedItem])
    case error(Error)
}

protocol FeedLoader {
    func load(completion: @escaping (LoadFeedResult) -> Void)
}
