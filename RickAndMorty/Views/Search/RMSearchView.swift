//
//  RMSearchView.swift
//  RickAndMorty
//
//  Created by Nimrod Borochov on 17/12/2023.
//

import UIKit

protocol RMSearchViewDelegate: AnyObject {
    func rmSearchView(_ searchView: RMSearchView, didSelectOption option: RMSearchInputViewViewModel.DynamicOption)
}

final class RMSearchView: UIView {

    weak var delegate : RMSearchViewDelegate?

    let viewModel: RMSearchViewViewModel

    // MARK: - Subviews

    /// SearchInputView(bar, selection buttons)
    private let searchInputView = RMSearchInputView()

    /// No results view
    private let noResultsView = RMNoSearchResultsView()

    // Results collectionView

    // MARK: - Init

    init(frame: CGRect, viewModel: RMSearchViewViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        backgroundColor = .systemBackground
        translatesAutoresizingMaskIntoConstraints = false
        addSubviews(noResultsView, searchInputView)
        addConstraints()

        searchInputView.configure(with: .init(type: viewModel.config.type))
        searchInputView.delegate = self

        viewModel.registerOptionChangeBlock { [weak self] tuple in
            // tuple: Option | newValue
            self?.searchInputView.update(option: tuple.0, value: tuple.1)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addConstraints() {
        let searchInputViewHeightAnchorConstant: CGFloat = viewModel.config.type == .episode ? 55 : 110

        NSLayoutConstraint.activate([
            // Search input
            searchInputView.topAnchor.constraint(equalTo: topAnchor),
            searchInputView.leftAnchor.constraint(equalTo: leftAnchor),
            searchInputView.rightAnchor.constraint(equalTo: rightAnchor),
            searchInputView.heightAnchor.constraint(equalToConstant: searchInputViewHeightAnchorConstant),

            // No results
            noResultsView.widthAnchor.constraint(equalToConstant: 150),
            noResultsView.heightAnchor.constraint(equalToConstant: 150),
            noResultsView.centerXAnchor.constraint(equalTo: centerXAnchor),
            noResultsView.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }

    public func presentKeyboard() {
        searchInputView.presentKeyboard()
    }
}

// MARK: - CollectionView

extension RMSearchView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)


    }
}

// MARK: - RMSearchInputViewDelegate

extension RMSearchView: RMSearchInputViewDelegate {
    func rmSearchInputView(_ inputView: RMSearchInputView, didSelectOption option: RMSearchInputViewViewModel.DynamicOption) {
        delegate?.rmSearchView(self, didSelectOption: option)
    }

    func rmSearchInputView(_ inputView: RMSearchInputView, didChangeSearchText text: String) {
        viewModel.setSearchText(text)
    }

    func rmSearchInputViewDidTapSearchKeyboardButton(_ inputView: RMSearchInputView) {
        viewModel.executeSearch()
    }
}
