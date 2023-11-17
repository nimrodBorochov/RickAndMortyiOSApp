//
//  RMEpisodeDetailViewViewModel.swift
//  RickAndMorty
//
//  Created by Nimrod Borochov on 14/11/2023.
//

import UIKit

protocol RMEpisodeDetailViewViewModelDelegate: AnyObject {
    func didFetchEpisodeDetails()
}

final class RMEpisodeDetailViewViewModel {
    private let endpointUrl: URL?
    private var dataTuple: (RMEpisode, [RMCharacter])? {
        didSet {
            delegate?.didFetchEpisodeDetails()
        }
    }

    enum SectionType {
        case information(viewModels: [RMEpisodeInfoCollectionViewCellViewModel])
        case character(viewModel: [RMCharacterCollectionViewCellViewModel])
    }

    public weak var delegate: RMEpisodeDetailViewViewModelDelegate?

    public private(set) var section: [SectionType] = []

    // MARK: - Init

    init(endpointUrl: URL?) {
        self.endpointUrl = endpointUrl
    }
    
    // MARK: - Public

    // MARK: - Private

    /// Fetch backing episode model
    public func fetchEpisodeData() {
        guard let endpointUrl, let request = RMRequest(url: endpointUrl) else {
            return
        }

        RMService.shared.execute(request,
                                 expecting: RMEpisode.self) { [weak self] result in
            guard let self else { return }

            switch result {
            case .success(let model):
                self.fetchRelatedCharacters(episode: model)
            case .failure:
                break
            }
        }
    }

    private func fetchRelatedCharacters(episode: RMEpisode) {
        let requests: [RMRequest] = episode.characters
            .compactMap { URL(string: $0) }
            .compactMap { RMRequest(url: $0) }

        // parallel request, notified when all done
        let group = DispatchGroup()

        var characters: [RMCharacter] = []

        for request in requests {
            group.enter()
            RMService.shared.execute(request, expecting: RMCharacter.self) { result in
                defer {
                    group.leave()
                }
                switch result {
                case .success(let model):
                    characters.append(model)
                case .failure:
                    break
                }
            }
        }

        group.notify(queue: .main) {
            self.dataTuple = (episode, characters)
        }
    }
}
