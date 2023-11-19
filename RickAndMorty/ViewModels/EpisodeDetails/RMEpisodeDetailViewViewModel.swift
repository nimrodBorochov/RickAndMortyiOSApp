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
    private var dataTuple: (episode: RMEpisode, characters: [RMCharacter])? {
        didSet {
            createCellViewModels()
            delegate?.didFetchEpisodeDetails()
        }
    }

    enum SectionType {
        case information(viewModels: [RMEpisodeInfoCollectionViewCellViewModel])
        case characters(viewModels: [RMCharacterCollectionViewCellViewModel])
    }

    public weak var delegate: RMEpisodeDetailViewViewModelDelegate?

    public private(set) var cellViewModels: [SectionType] = []

    // MARK: - Init

    init(endpointUrl: URL?) {
        self.endpointUrl = endpointUrl
    }

    // MARK: - Public

    public func character(at index: Int) -> RMCharacter? {
        guard let dataTuple else { return nil}
        return dataTuple.characters[index]
    }

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

    // MARK: - Private
    private func createCellViewModels() {
        guard let dataTuple else { return }
        let episode = dataTuple.episode
        let characters = dataTuple.characters

        var createdString = episode.created
        if let date = RMCharacterInfoCollectionViewCellViewModel.dateFormatter.date(from: episode.created) {
            createdString = RMCharacterInfoCollectionViewCellViewModel.shortDateFormatter.string(from: date) 
        }

        cellViewModels = [
            .information(viewModels: [
                .init(title: "Episode Name", value: episode.name),
                .init(title: "Air Date", value: episode.air_date),
                .init(title: "Episode", value: episode.episode),
                .init(title: "Created", value: createdString),
            ]),
            .characters(viewModels: characters.compactMap({ character in
                return RMCharacterCollectionViewCellViewModel(
                    characterName: character.name,
                    characterStatus: character.status,
                    characterImageUrl: URL(string: character.image)
                )
            }))
        ]
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
            self.dataTuple = (
                episode: episode,
                characters: characters
            )
        }
    }
}
