//
//  MovieDataFetcherProtocol.swift
//  IMDBMovies
//
//  Created by Akshay Bhandary on 9/9/22.
//

import Foundation

enum MovieDataFetcherError : Error {
  case decodingError
  case networkError
}

typealias MovieDataFetchResultCompletion = (Result<Response, MovieDataFetcherError>) -> Void

protocol MovieDataFetcherProtocol {
  func fetchMovies(usingSearchString searchString: String, completion: @escaping MovieDataFetchResultCompletion)
}
