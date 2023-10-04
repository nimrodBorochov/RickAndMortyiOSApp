//
//  RMImageManager.swift
//  RickAndMorty
//
//  Created by Nimrod Borochov on 04/10/2023.
//

import Foundation

final class RMImageManager {
    static let shared = RMImageManager()

    private var ImageDataCache = NSCache<NSString, NSData>()

    private init() {}
    
    /// Get image content with URL
    /// - Parameters:
    ///   - url: Source URL
    ///   - completion: Callback
    func downloadImage(_ url: URL, completion: @escaping (Result<Data, Error>) -> Void ) {
        let key = url.absoluteString as NSString
        if let data = ImageDataCache.object(forKey: key) {
            completion(.success(data as Data))
            return
        }

        let request = URLRequest(url: url)
        // TODO: check if change task to async
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            guard let self else { return }
            guard let data, error == nil else {
                completion(.failure(error ?? URLError(.badServerResponse)))
                return
            }
            let value = data as NSData
            self.ImageDataCache.setObject(value, forKey: key)
            completion(.success(data))
        }
        task.resume()
    }
}
