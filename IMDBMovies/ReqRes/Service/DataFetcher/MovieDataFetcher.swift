//
//  MovieDataFetcher.swift
//  IMDBMovies
//
//  Created by Akshay Bhandary on 9/9/22.
//

import Foundation

private let TAG = "MovieDataFetcher"

final class MovieDataFetcher : MovieDataFetcherProtocol {
  
  private var session: NetworkSessionProtocol
  private var decoder: JSONDecodable
  
  private let api: API = .searchMovies
  static let shared = MovieDataFetcher()
  
  init(session: NetworkSessionProtocol = URLSession.nocache, decoder: JSONDecodable = MovieDecoder()) {
    self.session = session
    self.decoder = decoder
  }
}

extension MovieDataFetcher {
  func fetchMovies(usingSearchString searchString: String, completion: @escaping MovieDataFetchResultCompletion) {
    self.session.loadData(from: api, params: searchString) { [weak self] result in
      guard let self = self else {
        Log.error("self is nil")
        return
      }
      switch (result) {
      case .success(let data):
        if let response = self.decodeMovie(data: data) {
          completion(.success(response))
        } else {
          completion(.failure(.decodingError))
        }
      case .failure(let error):
        Log.error(TAG, "fetchMovies: got an error - \(error)")
        completion(.failure(.networkError))
      }
    }
  }
  
  private func decodeMovie(data: Data) -> MovieResponse? {
    return self.decoder.decode(type: MovieResponse.self, from: data)
  }
}

