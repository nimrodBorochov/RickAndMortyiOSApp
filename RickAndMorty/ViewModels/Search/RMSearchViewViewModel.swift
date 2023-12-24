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

    private var searchResultHandler: (() -> Void)?

    // MARK: - Init

    init(config: RMSearchViewController.Config) {
        self.config = config
    }

    // MARK: - Public
    public func registerSearchResultHandler(_ block: @escaping () -> Void) {
        self.searchResultHandler = block
    }

    public func executeSearch() {
        // Create Request based on filters
        print("Search text: \(searchText)")

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
        // Create request
        let request = RMRequest(
            endpoint: config.type.endPoint,
            queryParameters: queryParams
        )

        RMService.shared.execute(request,
                                 expecting: RMGetAllCharactersResponse.self) { results in

            switch results {
            case .success(let model):
                print("Search result found: \(model.results.count)")
            case .failure:
                //TODO: handel
                break
            }
        }

        // Notify view of results, no results, or error

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
