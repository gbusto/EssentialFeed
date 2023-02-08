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
        // NOTE: We have created tightly couple test code to test this specific API.
        session.dataTask(with: url) { _, _, _ in }.resume()
    }
}

class URLSessionHTTPClientTests: XCTestCase {
    
    // The test that was here testing "createsDataTaskWithURL" is unnecessary now, because the resumesDataTaskWithURL test already tests this.
    
    func test_getFromURL_resumesDataTaskWithURL() {
        let url = URL(string: "https://any-url.com")!
        let session = URLSessionSpy()
        let task = URLSessionDataTaskSpy()
        session.stub(url: url, task: task)
        
        let sut = URLSessionHTTPClient(session: session)
        
        sut.get(from: url)
        
        XCTAssertEqual(task.resumeCallCount, 1)
    }
    
    // MARK: - Helpers
    
    // We created these mock classes that we don't own and could change. It could lead to us making assumptions in our mocked behavior that could be wrong.
    // These types contain a bunch of methods that we're not overriding, and they might be interoperating between them. This is a big assumption here.
    
    private class URLSessionSpy: URLSession {
        private var stubs = [URL: URLSessionDataTask]()
        
        func stub(url: URL, task: URLSessionDataTask) {
            stubs[url] = task
        }
        
        override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
            return stubs[url] ?? FakeURLSessionDataTask()
        }
    }
    
    private class FakeURLSessionDataTask: URLSessionDataTask {
        // We override this function here because this gets returned to a test that needs to be able to call resume. This is a problem testing something like a mocked URLSession, because we need this call in here due to the way URLSessionDataTasks work
        override func resume() {}
    }
    
    private class URLSessionDataTaskSpy: URLSessionDataTask {
        var resumeCallCount = 0
        
        override func resume() {
            resumeCallCount += 1
        }
    }

}
