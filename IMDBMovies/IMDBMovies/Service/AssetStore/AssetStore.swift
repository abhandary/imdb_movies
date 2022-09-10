//
//  AssetStore.swift
//  IMDBMovies
//
//  Created by Akshay Bhandary on 7/3/22.
//

import Foundation


private let TAG = "AssetStore"

struct AssetStore {

  var imageCache = NSCache<NSString, NSData>()
  
  func fetchAsset(url: URL?) -> Asset {
    guard let url = url else {
      Log.error(TAG, "attempt to fetch using nil url, returning placeholder")
      return Asset(url: nil, state: .placeholder, data: nil)
    }
    if let cachedAsset = imageCache.object(forKey: url.path as NSString) {
      return Asset(url: url, state: .downloaded, data: cachedAsset as Data)
    }
    return Asset(url: url, state: .placeholder, data: nil)
  }
  
  func downloadAsset(url: URL?, completionHandler: @escaping (Asset) -> Void) {
    guard let url = url else {
      Log.error(TAG, "attempt to fetch using nil url, returning placeholder")
      completionHandler(Asset(url: nil, state: .placeholder, data: nil))
      return
    }
    
    if let cachedAsset = imageCache.object(forKey: url.path as NSString) {
      completionHandler(Asset(url: url, state: .downloaded, data: cachedAsset as Data))
    } else {
      URLSession.shared.dataTask(with: url) { (data, response, error) in
        if let error = error {
          Log.error(TAG, error)
        }
        guard let data = data else {
          Log.error(TAG, "no data fetched")
          return
        }
        
        imageCache.setObject(data as NSData, forKey: url.path as NSString)
        completionHandler(Asset(url: url, state: .downloaded, data: data))
      }.resume()
    }
  }
}
