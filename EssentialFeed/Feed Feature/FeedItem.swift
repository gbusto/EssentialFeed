//
//  FeedItem.swift
//  EssentialFeed
//
//  Created by Gabriel Busto on 2/2/23.
//

import Foundation

public struct FeedItem: Equatable {
    public let id: UUID
    public let description: String?
    public let location: String?
    public let imageURL: URL
    
    public init(id: UUID, description: String?, location: String?, imageURL: URL) {
        self.id = id
        self.description = description
        self.location = location
        self.imageURL = imageURL
    }
}

extension FeedItem: Decodable {
    // Provide mapping instructions because FeedItem has imageURL,
    // but the JSON key needs to be "image"
    private enum CodingKeys: String, CodingKey {
        case id
        case description
        case location
        // Red flag! This line below is an API detail that leaked into our feature module.
        // This creates a tight coupling to the RemoteFeedLoader and is a detail of the RemoteFeedLoader that may not also apply to the LocalFeedLoader for example.
        // This harmless string in the wrong module can end up breaking our abstractions :(
        case imageURL = "image"
    }
}
