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
        sut.load()
        
        // "Assert" part of Arrange, Act, Assert
        // Then we assert that a URL request was intiated in the client
        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    func test_loadTwice_requestsDataFromURLTwice() {
        let url = URL(string: "https://a-given-url.com")!
        let (sut, client) = makeSUT(url: url)
        
        sut.load()
        sut.load()
        
        XCTAssertEqual(client.requestedURLs, [url, url])
    }
    
    func test_load_deliversErrorOnClientError() {
        // Arrange: Given the sut and its HTTP client spy
        let (sut, client) = makeSUT()
        
        /*
         Changed the "Arrange" and "Act" part of the test.
         Client.error stub was part of Arrange, now client.completions is in Act
         This is because when the client completes with an error, we want the load to complete with an error also.
         */
        
        // Act: When we tell the sut to load and we complete the client's HTTP request with an error
        var capturedErrors: [RemoteFeedLoader.Error] = []
        sut.load { capturedErrors.append($0) }
        
        let clientError = NSError(domain: "Test", code: 0)
        client.complete(with: clientError)
        
        // Assert: Then we expect the captured load error to be a connectivity error
        XCTAssertEqual(capturedErrors, [.connectivity])
    }
    
    // MARK: - Helpers
    
    private func makeSUT(url: URL = URL(string: "https://a-url.com")!) -> (sut: RemoteFeedLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(url: url, client: client)
        return (sut, client)
    }
    
    private class HTTPClientSpy: HTTPClient {
        var requestedURLs = [URL]()
        var completions = [(Error) -> Void]()
        
        func get(from url: URL, completion: @escaping (Error) -> Void) {
            completions.append(completion)
            requestedURLs.append(url)
        }
        
        func complete(with error: Error, at index: Int = 0) {
            completions[index](error)
        }
    }
}
