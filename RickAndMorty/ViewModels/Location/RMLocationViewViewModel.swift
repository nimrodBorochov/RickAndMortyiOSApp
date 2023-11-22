//
//  RMLocationViewViewModel.swift
//  RickAndMorty
//
//  Created by Nimrod Borochov on 22/11/2023.
//

import Foundation

final class RMLocationViewViewModel {
    
    private var locations: [RMLocation] = []

    // Location response info
    // Will contain next url, if present

    private var cellViewModels: [String] = []



    public func fetchLocations() {
        RMService.shared.execute(.listLocationsRequest, expecting: String.self) { result in
            switch result {
            case .success(let model):
                break
            case .failure(let failure):
                break
            }
        }
    }

    private var hasMoreResults: Bool {
        return false
    }
}
