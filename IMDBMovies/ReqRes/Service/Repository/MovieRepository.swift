//
//  MovieRepository.swift
//  IMDBMovies
//
//  Created by Akshay Bhandary on 9/9/22.
//

import Foundation

private let TAG = "MovieRepository"

// This module is the 'source of truth' and has the ability to fetch from data store
// while data is fetched from the network
final class MovieRepository : MovieRepositoryProtocol {
  
  let dataFetcher: MovieDataFetcherProtocol

  init(dataFetcher: MovieDataFetcherProtocol) {
    self.dataFetcher = dataFetcher
  }
  
  func fetchMovies(usingSearchString searchString: String, completion: @escaping MovieRepoResultCompletion) {

    Log.verbose(TAG,"running query for movies using search string - \(searchString)")
    
    fetchWithDataFetcherMovies(usingSearchString: searchString, completion: completion)
  }
  
  private func fetchWithDataFetcherMovies(usingSearchString searchString: String,
                                          completion: @escaping MovieRepoResultCompletion) {
    // async fetch from network and update and notify
    dataFetcher.fetchMovies(usingSearchString: searchString) { [weak self] result in
      guard let self = self else {
        Log.error(TAG, "self is nil")
        completion(.failure(.unexpected))
        return
      }
      switch (result) {
      case .success(let response):
        completion(.success(response.movies))
      case .failure(let error):
        Log.error(TAG, error)
        completion(.failure(self.map(networkError: error)))
      }
    }
  }
  
  private func map(networkError: MovieDataFetcherError) ->  MovieRepositoryError {
    switch (networkError) {
    case .networkError:
      return .networkError
    case .decodingError:
      return .decodingError
    }
  }
}

