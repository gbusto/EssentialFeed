//
//  URLSessionHTTPClientTests.swift
//  EssentialFeedTests
//
//  Created by Gabriel Busto on 2/8/23.
//

import Foundation
import XCTest

class URLSessionHTTPClient {
    private let session: URLSession
    
    // Constructor injection for this test implementation
    init(session: URLSession) {
        self.session = session
    }
    
    func get(from url: URL) {
        session.dataTask(with: url) { _, _, _ in }
    }
}

class URLSessionHTTPClientTests: XCTestCase {
    
    func test_getFromURL_createsDataTaskWithURL() {
        let url = URL(string: "https://any-url.com")!
        let session = URLSessionSpy()
        let sut = URLSessionHTTPClient(session: session)
        
        sut.get(from: url)
        
        XCTAssertEqual(session.receivedURLs, [url])
    }
    
    // MARK: - Helpers
    
    // We created these mock classes that we don't own and could change. It could lead to us making assumptions in our mocked behavior that could be wrong.
    // These types contain a bunch of methods that we're not overriding, and they might be interoperating between them. This is a big assumption here.
    
    private class URLSessionSpy: URLSession {
        var receivedURLs = [URL]()
        
        override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
            receivedURLs.append(url)
            
            return FakeURLSessionDataTask()
        }
    }
    
    private class FakeURLSessionDataTask: URLSessionDataTask {}
    
}
