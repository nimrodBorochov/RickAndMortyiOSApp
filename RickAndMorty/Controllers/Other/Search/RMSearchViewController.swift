//
//  RMSearchViewController.swift
//  RickAndMorty
//
//  Created by Nimrod Borochov on 14/11/2023.
//

import UIKit

// Dynamic search option view
// Render Results
// Render no results zero state
// Searching: API Call

/// Configurable controller to search
final class RMSearchViewController: UIViewController {
    
    /// Configuration for search session
    struct Config {
        enum `Type` {
            case character // name | status | gender
            case episode // name
            case location // name | type

            var title: String {
                switch self {
                case .character:
                    return "Search Character"
                case .episode:
                    return "Search Episode"
                case .location:
                    return "Search Location"
                }
            }
        }

        let type: `Type`
    }

    private let viewModel : RMSearchViewViewModel

    private let searchView: RMSearchView

    // MARK: - Init

    init(config: Config) {
        viewModel = RMSearchViewViewModel(config: config)
        searchView = RMSearchView(frame: .zero, viewModel: viewModel)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = viewModel.config.type.title
        view.backgroundColor = .systemBackground
        view.addSubview(searchView)
        addConstraints()
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Search",
            style: .done,
            target: self,
            action: #selector(didTapSearch)
        )
        searchView.delegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchView.presentKeyboard()  
    }

    @objc
    private func didTapSearch() {
//        viewModel.executeSearch() 
    }

    private func addConstraints() {
        NSLayoutConstraint.activate([
            searchView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            searchView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            searchView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}

// MARK: - RMSearchViewDelegate

extension RMSearchViewController: RMSearchViewDelegate {
    func rmSearchView(_ searchView: RMSearchView, didSelectOption option: RMSearchInputViewViewModel.DynamicOption) {
        let vc = RMSearchOptionsPickerViewController(option: option) { selection in
            print("did select \(selection))
        }
        vc.sheetPresentationController?.detents = [.medium()]
        present(vc, animated: true)
    }
}
