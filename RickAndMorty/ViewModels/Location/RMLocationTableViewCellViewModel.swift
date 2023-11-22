//
//  RMLocationTableViewCellViewModel.swift
//  RickAndMorty
//
//  Created by Nimrod Borochov on 22/11/2023.
//

import Foundation

struct RMLocationTableViewCellViewModel: Hashable, Equatable {
    
    private let location: RMLocation

    init(location: RMLocation) {
        self.location = location
    }

    public var name: String {
        location.name
    }

    public var type: String {
        location.type
    }

    public var dimension: String {
        location.dimension
    }

    static func == (lhs: RMLocationTableViewCellViewModel, rhs: RMLocationTableViewCellViewModel) -> Bool {
        lhs.location.id == rhs.location.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(location.id)
//        hasher.combine(name)
//        hasher.combine(type)
//        hasher.combine(dimension)
    }
}
