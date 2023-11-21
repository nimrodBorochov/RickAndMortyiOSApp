//
//  RMSettingsCellViewViewModel.swift
//  RickAndMorty
//
//  Created by Nimrod Borochov on 20/11/2023.
//

import UIKit

struct RMSettingsCellViewViewModel: Identifiable {
    let id = UUID()

    private let type: RMSettingsOption

    // MARK: - Init

    init(type: RMSettingsOption) {
        self.type = type
    }

    // MARK: - Public

    public var image: UIImage? { type.iconImage }
    public var title: String { type.displayTitle }
    public var iconContainerColor: UIColor { type.iconContainerColor }


}
