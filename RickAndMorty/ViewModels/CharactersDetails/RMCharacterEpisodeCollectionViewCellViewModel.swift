//
//  RMCharacterEpisodeCollectionViewCellViewModel.swift
//  RickAndMorty
//
//  Created by Nimrod Borochov on 04/10/2023.
//

import Foundation

final class RMCharacterEpisodeCollectionViewCellViewModel {
    private let episodeDataUrl: URL?

    init(episodeDataUrl: URL?) {
        self.episodeDataUrl = episodeDataUrl
    }
}
