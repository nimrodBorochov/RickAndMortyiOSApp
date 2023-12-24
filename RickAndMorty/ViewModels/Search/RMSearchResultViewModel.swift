//
//  RMSearchResultViewModel.swift
//  RickAndMorty
//
//  Created by Nimrod Borochov on 24/12/2023.
//

import Foundation

enum RMSearchResultViewModel {
    case characters([RMCharacterCollectionViewCellViewModel])
    case episodes([RMCharacterEpisodeCollectionViewCellViewModel])
    case locations([RMLocationTableViewCellViewModel])
}
