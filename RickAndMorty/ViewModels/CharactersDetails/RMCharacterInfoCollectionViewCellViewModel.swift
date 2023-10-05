//
//  RMCharacterInfoCollectionViewCellViewModel.swift
//  RickAndMorty
//
//  Created by Nimrod Borochov on 04/10/2023.
//

import Foundation

final class RMCharacterInfoCollectionViewCellViewModel {
    public let value: String
    public let title: String

    init(value: String, title: String) {
        self.value = value
        self.title = title
    }
}
