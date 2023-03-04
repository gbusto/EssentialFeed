//
//  CacheFeedUseCaseTests.swift
//  EssentialFeedTests
//
//  Created by Gabriel Busto on 3/4/23.
//

import XCTest

class LocalFeedLoader {
    init(store: FeedStore) {
        
    }
}

// This helper class represents the framework side to help us define the abstract interface the
// use case needs for its collaborator, making sure not to leak framework details into the Use Case
class FeedStore {
    var deleteCachedFeedCallCount = 0
}

class CacheFeedUseCaseTests: XCTestCase {
    
    func test_init_doesNotDeleteCacheUponCreation() {
        let store = FeedStore()
        _ = LocalFeedLoader(store: store)
        
        XCTAssertEqual(store.deleteCachedFeedCallCount, 0)
    }
}
