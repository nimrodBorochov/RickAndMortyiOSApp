//
//  RMTabBarController.swift
//  RickAndMorty
//
//  Created by Nimrod Borochov on 02/10/2023.
//

import UIKit

final class RMTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        setupTabs()
    }

    private func setupTabs() {
        let charactersVC = RMCharacterViewController()
        let locationsVC = RMLocationViewController()
        let episodesVC = RMEpisodeViewController()
        let settingsVC = RMSettingsViewController()

        charactersVC.navigationItem.largeTitleDisplayMode = .automatic
        locationsVC.navigationItem.largeTitleDisplayMode = .automatic
        episodesVC.navigationItem.largeTitleDisplayMode = .automatic
        settingsVC.navigationItem.largeTitleDisplayMode = .automatic

        let charactersNavigationController = UINavigationController(rootViewController: charactersVC)
        let locationsNavigationController = UINavigationController(rootViewController: locationsVC)
        let episodesNavigationController = UINavigationController(rootViewController: episodesVC)
        let settingsNavigationController = UINavigationController(rootViewController: settingsVC)

        charactersNavigationController.tabBarItem = UITabBarItem(title: "Characters",
                                                                 image: UIImage(systemName: "person"),
                                                                 tag: 1)

        locationsNavigationController.tabBarItem = UITabBarItem(title: "Locations",
                                                                image: UIImage(systemName: "globe"),
                                                                 tag: 2)

        episodesNavigationController.tabBarItem = UITabBarItem(title: "Episodes",
                                                               image: UIImage(systemName: "tv"),
                                                                 tag: 3)

        settingsNavigationController.tabBarItem = UITabBarItem(title: "Settings ",
                                                               image: UIImage(systemName: "gear"),
                                                                 tag: 4)

        let navigations = [
            charactersNavigationController,
            locationsNavigationController,
            episodesNavigationController,
            settingsNavigationController
        ]

        for navigation in navigations {
            navigation.navigationBar.prefersLargeTitles = true
        }

        setViewControllers(
            navigations,
            animated: true
        )
    }
}

