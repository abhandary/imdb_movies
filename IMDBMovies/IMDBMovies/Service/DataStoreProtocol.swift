//
//  ReqResDataStoreProtocol.swift
//  IMDB Movies
//
//  Created by Akshay Bhandary on 7/1/22.
//

import Foundation

protocol DataStoreProtocol {
  func fetchMovies(usingSearchString searchString: String) async -> [Movie]? 
  func write(response: Response, usingSearchString searchString: String) async
}
