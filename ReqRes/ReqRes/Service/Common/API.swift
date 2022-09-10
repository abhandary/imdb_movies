//
//  API.swift
//  IMDBMovies
//
//  Created by Akshay Bhandary on 9/9/22.
//

import Foundation

enum API {
  case searchMovies
}

extension API: EndPoint {
  var path: String {
    switch self {
    case .searchMovies:
      return "https://imdb-api.com/en/API/SearchMovie/"
    }
  }
  
  var request: URLRequest? {
    guard let url = URL(string: path) else { return nil }
    return URLRequest(url: url)
  }
}
