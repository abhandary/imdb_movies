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
}

typealias MovieDataStoreResultCompletion = (Result<[Movie], MovieDataStoreError>) -> Void

protocol MovieDataStoreProtocol {
  func fetchMovies(usingSearchString searchString: String, completion: @escaping MovieDataStoreResultCompletion)
  func write(response: Response, usingSearchString searchString: String) async
}
