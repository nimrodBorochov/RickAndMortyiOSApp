//
//  RMEpisodeDetailViewController.swift
//  RickAndMorty
//
//  Created by Nimrod Borochov on 05/10/2023.
//

import UIKit

/// ViewController to show details about single episode
final class RMEpisodeDetailViewController: UIViewController {

    private let viewModel: RMEpisodeDetailViewViewModel

    private let detailView = RMEpisodeDetailView()

    // MARK: - Init

    init(url: URL?) {
        self.viewModel = RMEpisodeDetailViewViewModel(endpointUrl: url)

        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(detailView)
        addConstraint()
        title = "Episode"

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(didTapShare))

        viewModel.delegate = self
        viewModel.fetchEpisodeData()
    }

    private func addConstraint(){
        NSLayoutConstraint.activate([
            detailView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            detailView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            detailView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            detailView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    @objc
    private func didTapShare() {

    }
}

// MARK: - Delegate

extension RMEpisodeDetailViewController: RMEpisodeDetailViewViewModelDelegate {
    func didFetchEpisodeDetails() {
        detailView.configure(with: viewModel)
    }

}
