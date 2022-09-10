//
//  EndPoint.swift
//  IMDBMovies
//
//  Created by Akshay Bhandary on 9/9/22.
//

import Foundation

public protocol EndPoint {
  var path: String { get }
  var request: URLRequest? { get }
  func request(withParams params: String) -> URLRequest?
}
