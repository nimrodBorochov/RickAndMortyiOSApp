//
//  RMLocationViewController.swift
//  RickAndMorty
//
//  Created by Nimrod Borochov on 02/10/2023.
//

import UIKit

/// Controller to show and search for Locations
final class RMLocationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Locations"
        addSearchButton()
    }

    private func addSearchButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(didTapSearch))
    }

    @objc
    private func didTapSearch() {

    }
}
