//
//  RMEpisodeDetailViewController.swift
//  RickAndMorty
//
//  Created by Nimrod Borochov on 05/10/2023.
//

import UIKit

/// ViewController to show details about single episode
final class RMEpisodeDetailViewController: UIViewController {

    private let url: URL?

    init(url: URL?) {
        self.url = url

        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Episode"
        view.backgroundColor = .systemGreen
    }

}
