//
//  RemoteFeedLoaderTests.swift
//  EssentialFeedTests
//
//  Created by Gabriel Busto on 2/3/23.
//

import XCTest
import EssentialFeed

class RemoteFeedLoaderTest: XCTestCase {
    func test_init_doesNotRequestDataFromURL() {
        let (_, client) = makeSUT()
        
        XCTAssertEqual(client.requestedURLs, [])
    }
    
    func test_load_requestsDataFromURL() {
        // Load items command
        
        // How can the RemoteFeedLoader invoke the method in the client?
        // Could pass it into the constructor for the RFL (constructor injection),
        //  could set it as a property and leverage dependency inject,
        //  OR could pass it as a parameter in sut.load() (parameter injection)
        // You can also set it up as a Singleton to make it easier to access it, but it doesn't need to be
        
        let url = URL(string: "https://a-given-url.com")!
        
        // "Arrange" part of Arrange, Act, Assert
        // Given a client and a sut...
        let (sut, client) = makeSUT(url: url)
        
        // "Act" part of Arrange, Act, Assert
        // When we invoke sut.load()...
        sut.load { _ in }
        
        // "Assert" part of Arrange, Act, Assert
        // Then we assert that a URL request was intiated in the client
        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    func test_loadTwice_requestsDataFromURLTwice() {
        let url = URL(string: "https://a-given-url.com")!
        let (sut, client) = makeSUT(url: url)
        
        sut.load { _ in }
        sut.load { _ in }
        
        XCTAssertEqual(client.requestedURLs, [url, url])
    }
    
    func test_load_deliversErrorOnClientError() {
        let (sut, client) = makeSUT()
        
        expect(sut, toCompleteWithError: .connectivity, when: {
            let clientError = NSError(domain: "Test", code: 0)
            client.complete(with: clientError)
        })
    }
    
    func test_load_deliversErrorOnNon200HTTPResponse() {
        let (sut, client) = makeSUT()
        
        let samples = [199, 201, 300, 400, 500]
        
        samples.enumerated().forEach { index, code in
            expect(sut, toCompleteWithError: .invalidData, when: {
                client.complete(withStatusCode: code, at: index)
            })
        }
    }
    
    func test_load_deliversErrorOn200HTTPResponseWithInvalidJSON() {
        let (sut, client) = makeSUT()
        
        expect(sut, toCompleteWithError: .invalidData, when: {
            let invalidJSON = Data(bytes: "invalid json".utf8)
            client.complete(withStatusCode: 200, data: invalidJSON)
        })
    }
    
    // MARK: - Helpers
    
    private func makeSUT(url: URL = URL(string: "https://a-url.com")!) -> (sut: RemoteFeedLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(url: url, client: client)
        return (sut, client)
    }
    
    private func expect(_ sut: RemoteFeedLoader,
                        toCompleteWithError error: RemoteFeedLoader.Error,
                        when action: () -> Void,
                        file: StaticString = #filePath,
                        line: UInt = #line) {
        
        var capturedResults: [RemoteFeedLoader.Result] = []
        sut.load { capturedResults.append($0) }

        action()
        
        // Adding `file` and `line` params to this function helps ensure that
        // the test error will show on the correct line.
        XCTAssertEqual(capturedResults, [.failure(error)], file: file, line: line)
    }
    
    private class HTTPClientSpy: HTTPClient {
        private var messages = [(url: URL, completion: (HTTPClientResult) -> Void)]()
        
        var requestedURLs: [URL] {
            return messages.map { $0.url }
        }
        
        func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void) {
            messages.append((url, completion))
        }
        
        func complete(with error: Error, at index: Int = 0) {
            messages[index].completion(.failure(error))
        }
        
        func complete(withStatusCode code: Int, data: Data = Data(), at index: Int = 0) {
            let response = HTTPURLResponse(url: requestedURLs[index],
                                           statusCode: code,
                                           httpVersion: nil,
                                           headerFields: nil)!
            messages[index].completion(.success(data, response))
        }
    }
}
