//
//  PhotoRecord.swift
//  IMDB Movies
//
//  Created by Akshay Bhandary on 7/2/22.
//

import Foundation
import UIKit

// This enum contains all the possible states a photo record can be in
enum AssetState {
  case placeholder, downloaded, failed
}

struct Asset {
  let url: URL?
  let state: AssetState
  let data: Data?
  
  init(url:URL?, state: AssetState, data: Data?) {
    self.url = url
    self.state = state
    self.data = data
  }
}
