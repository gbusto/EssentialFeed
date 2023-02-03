//
//  RemoteFeedLoaderTests.swift
//  EssentialFeedTests
//
//  Created by Gabriel Busto on 2/3/23.
//

import Foundation
import XCTest

class RemoteFeedLoader {
    func load() {
        HTTPClient.shared.get(from: URL(string: "https://a-url.com")!)
    }
}

class HTTPClient {
    static var shared = HTTPClient()
    
    func get(from url: URL) {
    }
}

class HTTPClientSpy: HTTPClient {
    override func get(from url: URL) {
        requestedURL = url
    }
    
    var requestedURL: URL?
}

class RemoteFeedLoaderTest: XCTestCase {
    func test_init_doesNotRequestDataFromURL() {
        let client = HTTPClientSpy()
        HTTPClient.shared = client
        _ = RemoteFeedLoader()
        
        XCTAssertNil(client.requestedURL)
    }
    
    func test_load_requestDataFromURL() {
        // Load items command
        
        // How can the RemoteFeedLoader invoke the method in the client?
        // Could pass it into the constructor for the RFL (constructor injection),
        //  could set it as a property and leverage dependency inject,
        //  OR could pass it as a parameter in sut.load() (parameter injection)
        // You can also set it up as a Singleton to make it easier to access it, but it doesn't need to be
        
        // "Arrange" part of Arrange, Act, Assert
        // Given a client and a sut...
        let client = HTTPClientSpy()
        HTTPClient.shared = client
        let sut = RemoteFeedLoader()
        
        // "Act" part of Arrange, Act, Assert
        // When we invoke sut.load()...
        sut.load()
        
        // "Assert" part of Arrange, Act, Assert
        // Then we assert that a URL request was intiated in the client
        XCTAssertNotNil(client.requestedURL)
    }
}
