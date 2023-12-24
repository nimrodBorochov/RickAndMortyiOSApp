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
    private var optionMap: [RMSearchInputViewViewModel.DynamicOption: String] = [:]
    private var searchText = ""

    private var optionMapUpdateBlock: (((RMSearchInputViewViewModel.DynamicOption, String)) -> Void)?

    private var searchResultHandler: ((RMSearchResultViewModel) -> Void)?

    // MARK: - Init

    init(config: RMSearchViewController.Config) {
        self.config = config
    }

    // MARK: - Public
    public func registerSearchResultHandler(_ block: @escaping (RMSearchResultViewModel) -> Void) {
        self.searchResultHandler = block
    }

    public func executeSearch() {
        // Create Request based on filters
        //
        // Build arguments
        var queryParams = [
            URLQueryItem(
                name: "name",
                value: searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            )
        ]

        // Add options
        queryParams.append(contentsOf: optionMap.enumerated().compactMap({ _, element in
            return URLQueryItem(name: element.key.queryArgument, value: element.value)
        }))

        // Send API Call
        //
        // Create request
        let request = RMRequest(
            endpoint: config.type.endPoint,
            queryParameters: queryParams
        )

        switch config.type.endPoint {

        case .character:
            makeSearchAPICall(RMGetAllCharactersResponse.self, request: request)
        case .location:
            makeSearchAPICall(RMGetAllLocationsResponse.self, request: request)
        case .episode:
            makeSearchAPICall(RMGetAllEpisodesResponse.self, request: request)
        }
        // Notify view of results, no results, or error

    }

    private func makeSearchAPICall<T: Codable>(_ type: T.Type, request: RMRequest) {
        RMService.shared.execute(request,
                                 expecting: type) { [weak self] results in

            switch results {
            case .success(let model):
                self?.processSearchResult(model: model)
                // Episode, Characters: CollectionView; Location tableView

            case .failure:
                //TODO: handel
                break
            }
        }
    }

    private func processSearchResult(model: Codable) {
        var resultsVM: RMSearchResultViewModel?

        if let charactersResults = model as? RMGetAllCharactersResponse {
            resultsVM = .characters(charactersResults.results.compactMap({
                RMCharacterCollectionViewCellViewModel(
                    characterName: $0.name,
                    characterStatus: $0.status,
                    characterImageUrl: URL(string: $0.image)
                )
            }))
        }
        else if let episodesResults = model as? RMGetAllEpisodesResponse {
            resultsVM = .episodes(episodesResults.results.compactMap({
                RMCharacterEpisodeCollectionViewCellViewModel(episodeDataUrl: URL(string: $0.url))
            }))
        }
        else if let locationsResults = model as? RMGetAllLocationsResponse {
            resultsVM = .locations(locationsResults.results.compactMap({
                RMLocationTableViewCellViewModel(location: $0)
            }))
        }


        if let resultsVM {
            self.searchResultHandler?(resultsVM)
        }
        else {
            // Error: No result view
        }
    }

    public func setSearchText(_ text: String) {
        self.searchText = text
    }

    public func set(value: String, for option: RMSearchInputViewViewModel.DynamicOption) {
        optionMap[option] = value
        optionMapUpdateBlock?((option, value))
    }

    public func registerOptionChangeBlock(
        _ block: @escaping ((RMSearchInputViewViewModel.DynamicOption, String)) -> Void
    ) {
        self.optionMapUpdateBlock = block
    }
}
