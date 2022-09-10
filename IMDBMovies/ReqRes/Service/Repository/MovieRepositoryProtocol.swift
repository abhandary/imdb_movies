//
//  MovieRepositoryProtocol.swift
//  IMDBMovies
//
//  Created by Akshay Bhandary on 9/9/22.
//

import Foundation

enum MovieRepositoryError: Error {
  case unexpected
  case networkError
  case decodingError
}

typealias  MovieRepoResultCompletion = (Result<[Movie], MovieRepositoryError>) -> Void

protocol MovieRepositoryProtocol {
  func fetchMovies(usingSearchString searchString: String, completion: @escaping MovieRepoResultCompletion)
}
