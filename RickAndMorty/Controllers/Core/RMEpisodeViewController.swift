//
//  RMEpisodeViewController.swift
//  RickAndMorty
//
//  Created by Nimrod Borochov on 02/10/2023.
//

import UIKit

/// Controller to show and search for Episodes
final class RMEpisodeViewController: UIViewController {

    private let episodeListView = RMEpisodeListView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Episodes"
        setUpView()
    }

    private func setUpView() {
        episodeListView.delegate = self
        view.addSubview(episodeListView)
        NSLayoutConstraint.activate([
            episodeListView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            episodeListView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            episodeListView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            episodeListView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}

extension RMEpisodeViewController: RMEpisodeListViewDelegate {
    func rmEpisodeListView(_ episodeListView: RMEpisodeListView, didSelectEpisode episode: RMEpisode) {
        // Open detail controller for that episode
        // TODO: change to coordinator pattern
//        let viewModel = RMEpisodeDetailViewViewModel(endpointUrl: URL(string: episode.url))
        let detailVC = RMEpisodeDetailViewController(url: URL(string: episode.url))
        detailVC.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

