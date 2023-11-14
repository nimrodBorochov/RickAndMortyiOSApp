//
//  RMEpisodeDetailViewViewModel.swift
//  RickAndMorty
//
//  Created by Nimrod Borochov on 14/11/2023.
//

import UIKit

class RMEpisodeDetailViewViewModel {
    private let endpointUrl: URL?

    init(endpointUrl: URL?) {
        self.endpointUrl = endpointUrl
        fetchEpisodeData()
    }

    private func fetchEpisodeData() {
        guard let endpointUrl, let request = RMRequest(url: endpointUrl) else {
            return
        }

        RMService.shared.execute(request,
                                 expecting: RMEpisode.self) { result in
            switch result {
            case .success(let success):
                print(String(describing: success))
            case .failure(let failure):
                break
            }
        }
    }
}
