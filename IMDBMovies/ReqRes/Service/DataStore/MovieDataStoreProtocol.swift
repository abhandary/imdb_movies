//
//  ReqResDataStoreProtocol.swift
//  IMDB Movies
//
//  Created by Akshay Bhandary on 7/1/22.
//

import Foundation

enum MovieDataStoreError : Error {
  case fileURLCreationError
  case noStoredData
  case fileReadError
}

typealias MovieDataStoreResultCompletion = (Result<[Movie], MovieDataStoreError>) -> Void

protocol MovieDataStoreProtocol {
  func fetchMovies(usingSearchString searchString: String, completion: @escaping MovieDataStoreResultCompletion)
  func write(response: MovieResponse, usingSearchString searchString: String) async
}
