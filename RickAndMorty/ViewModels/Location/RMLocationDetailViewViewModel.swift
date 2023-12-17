//
//  RMLocationDetailViewViewModel.swift
//  RickAndMorty
//
//  Created by Nimrod Borochov on 24/11/2023.
//

import UIKit

protocol RMLocationDetailViewViewModelDelegate: AnyObject {
    func didFetchLocationDetails()
}

final class RMLocationDetailViewViewModel {
    private let endpointUrl: URL?
    private var dataTuple: (location: RMLocation, characters: [RMCharacter])? {
        didSet {
            createCellViewModels()
            delegate?.didFetchLocationDetails()
        }
    }

    enum SectionType {
        case information(viewModels: [RMEpisodeInfoCollectionViewCellViewModel])
        case characters(viewModels: [RMCharacterCollectionViewCellViewModel])
    }

    public weak var delegate: RMLocationDetailViewViewModelDelegate?

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

    /// Fetch backing location model
    public func fetchLocationData() {
        guard let endpointUrl, let request = RMRequest(url: endpointUrl) else {
            return
        }

        RMService.shared.execute(request,
                                 expecting: RMLocation.self) { [weak self] result in
            guard let self else { return }

            switch result {
            case .success(let model):
                self.fetchRelatedCharacters(location: model)
            case .failure:
                break
            }
        }
    }

    // MARK: - Private
    private func createCellViewModels() {
        guard let dataTuple else { return }
        let location = dataTuple.location
        let characters = dataTuple.characters

        var createdString = location.created
        if let date = RMCharacterInfoCollectionViewCellViewModel.dateFormatter.date(from: location.created) {
            createdString = RMCharacterInfoCollectionViewCellViewModel.shortDateFormatter.string(from: date)
        }

        cellViewModels = [
            .information(viewModels: [
                .init(title: "Location Name", value: location.name),
                .init(title: "Type", value: location.type),
                .init(title: "Dimension", value: location.dimension),
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



    private func fetchRelatedCharacters(location: RMLocation) {
        let requests: [RMRequest] = location.residents
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
                location: location,
                characters: characters
            )
        }
    }
}

