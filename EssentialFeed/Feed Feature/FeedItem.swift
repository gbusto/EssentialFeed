//
//  FeedItem.swift
//  EssentialFeed
//
//  Created by Gabriel Busto on 2/2/23.
//

import Foundation

public struct FeedItem: Equatable {
    let id: UUID
    let description: String?
    let location: String?
    let imageURL: URL
}
