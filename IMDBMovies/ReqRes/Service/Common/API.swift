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

private let TAG = "API"

extension API: EndPoint {
  var path: String {
    switch self {
    case .searchMovies:
      return "https://imdb-api.com/en/API/SearchMovie/k_6ik2kgb0/"
    }
  }
  
  var request: URLRequest? {
    guard let url = URL(string: path) else { return nil }
    return URLRequest(url: url)
  }
  
  func request(withParams params: String) -> URLRequest? {
    guard let params = params.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
      Log.error(TAG, "unable to percent escape params - \(params)")
      return nil
    }
    guard let url = URL(string: path + params) else { return nil }
    return URLRequest(url: url)
  }
}
