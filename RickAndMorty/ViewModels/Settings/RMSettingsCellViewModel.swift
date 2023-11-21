//
//  RMSettingsCellViewModel.swift
//  RickAndMorty
//
//  Created by Nimrod Borochov on 20/11/2023.
//

import UIKit

struct RMSettingsCellViewModel: Identifiable {
    let id = UUID()

    public let type: RMSettingsOption
    public let onTapHandler: (RMSettingsOption) -> Void
    // MARK: - Init

    init(type: RMSettingsOption, onTapHandler: @escaping (RMSettingsOption) -> Void) {
        self.type = type
        self.onTapHandler = onTapHandler
    }

    // MARK: - Public

    public var image: UIImage? { type.iconImage }
    public var title: String { type.displayTitle }
    public var iconContainerColor: UIColor { type.iconContainerColor }


}
