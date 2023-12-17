//
//  RMSearchViewViewModel.swift
//  RickAndMorty
//
//  Created by Nimrod Borochov on 17/12/2023.
//

import Foundation

// Responsibility
// - show search results
// - show no results view
// - kick off api requests

final class RMSearchViewViewModel {
    let config: RMSearchViewController.Config

    init(config: RMSearchViewController.Config) {
        self.config = config
    }
}
