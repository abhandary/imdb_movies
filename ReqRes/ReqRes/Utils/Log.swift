//
//  File.swift
//  IMDBMovies
//
//  Created by Akshay Bhandary on 7/3/22.
//

import Foundation

struct Log {
  static func error(_ tag: String, _ message: Any...) {
    print("\(tag): Error:", message)
  }
  
  static func verbose(_ tag: String, _ message: Any...) {
    print("\(tag): Verbose:", message)
  }
}
