//
//  ReqResNetworkLoader.swift
//  IMDB Movies
//
//  Created by Akshay Bhandary on 7/1/22.
//

import Foundation

struct NetworkLoader: NetworkLoaderProtocol {
  
  let API_KEY = "k_6ik2kgb0"
  let endpoint = "https://imdb-api.com/en/API/SearchMovie/"
  
  func queryForMovies(usingSearchString searchString: String) async -> Response? {
    print("queryForMovies: \(searchString)")
    guard searchString.count > 0 else {
      print("queryForMovies: empty search string, not running a query")
      return nil
    }
    let escapedSearchString =
      searchString.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
    guard let escapedSearchString = escapedSearchString,
          let endpointURL = URL(string: endpoint + API_KEY + "/" + escapedSearchString) else {
      print("end point URL is nil")
      return nil
    }
    print("queryForMovies: hitting endpoint URL - \(endpointURL)")
    do {
      let (data, _) = try await URLSession.shared.data(from: endpointURL)
      print(data)
      let response = try JSONDecoder().decode(Response.self, from: data)
      print("queryForMovies: Success, got a response")
      return response
    }
    catch {
      print("queryForMovies: Network request and decoding failed - \(error)")
    }
    return nil
  }
}
