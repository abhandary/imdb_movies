//
//  URLSession.swift
//  IMDBMovies
//
//  Created by Akshay Bhandary on 9/9/22.
//

import Foundation

extension URLSession {
  /// Use this `URLSession` so that your app always fetches the latest content and ignores cached data
  static let nocache: URLSession = {
    var configuration = URLSessionConfiguration.default
    configuration.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
    configuration.urlCache = nil
    return URLSession(configuration: configuration)
  }()
}
