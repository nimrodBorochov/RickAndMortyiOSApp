//
//  RMService.swift
//  RickAndMorty
//
//  Created by Nimrod Borochov on 02/10/2023.
//

import Foundation

/// Primary API service object to get Rick and Morty data.
final class RMService {
    ///  Shared singelton instance
    static let shared = RMService()
    
    /// Privatized contractor
    private init() {}
    
    /// Send Rick and Morty API Call
    /// - Parameters:
    ///   - request: Request instance
    ///   - completion: Callback with data or error
    public func execute(_ request: RMRequest, completion: @escaping () -> Void) {

    }
}
