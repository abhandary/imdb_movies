//
//  IReqResNetworkLoader.swift
//  IMDB Movies
//
//  Created by Akshay Bhandary on 7/1/22.
//

import Foundation

protocol NetworkLoaderProtocol {
  func queryForMovies(usingSearchString searchString: String) async -> Response? 
}
