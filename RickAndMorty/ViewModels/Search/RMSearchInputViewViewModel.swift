//
//  RMSearchInputViewViewModel.swift
//  RickAndMorty
//
//  Created by Nimrod Borochov on 17/12/2023.
//

import Foundation

final class RMSearchInputViewViewModel {

    private let type: RMSearchViewController.Config.`Type`

    enum DynamicOption: String {
        case status = "Status"
        case gender = "Gender"
        case locationType = "Location Type"

        var queryArgument: String {
            switch self {
            case .status: return "status"
            case .gender: return "gender"
            case .locationType: return "type"
            }
        }

        var choices: [String] {
            switch self {
            case .status:
                return ["alive", "dead", "unknown"]
            case .gender:
                return ["male", "female", "genderless", "unknown"]
            case .locationType:
                return ["cluster", "planet", "microverse", "space station", "tv", "Resort", "fantasy town", "dream"]
            }
        }
    }

    init(type: RMSearchViewController.Config.`Type`) {
        self.type = type
    }

    // MARK: - Public

//case character // name | status | gender
//case episode // name
//case location // name | type

    public var hasDynamicOptions: Bool {
        switch self.type {
        case .character, .location:
            return true
        case .episode:
            return false
        }
    }

    public var options: [DynamicOption] {
        switch self.type {
        case .character:
            return [.status, .gender]
        case .episode:
            return []
        case .location:
            return [.locationType]
        }
    }

    public var searchPlaceholderText: String {
        switch self.type {
        case .character:
            return "Character Name"
        case .episode:
            return "Episode Title"
        case .location:
            return "Location Name"
        }
    }
}
