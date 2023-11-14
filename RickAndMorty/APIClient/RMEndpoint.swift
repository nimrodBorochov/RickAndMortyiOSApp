//
//  RMEndpoint.swift
//  RickAndMorty
//
//  Created by Nimrod Borochov on 02/10/2023.
//

import Foundation

/// Represents unique API endpoints
@frozen enum RMEndpoint: String, CaseIterable, Hashable {
    /// Endpoint to get character info
    case character // "character"
    /// Endpoint to get location info
    case location
    /// Endpoint to get episode info
    case episode
}
