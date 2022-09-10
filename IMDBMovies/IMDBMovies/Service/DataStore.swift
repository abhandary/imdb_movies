//
//  ReqResDataStore.swift
//  IMDB Movies
//
//  Created by Akshay Bhandary on 7/1/22.
//

import Foundation

private let TAG = "DataStore"

struct DataStore: DataStoreProtocol {
  
  static private let storedSearchResultsLimit = 100
  
  let encoder = PropertyListEncoder()
  let decoder = PropertyListDecoder()
  
  init() {
    encoder.outputFormat = .binary
  }
  
  func fetchMovies(usingSearchString searchString: String) async -> [Movie]? {
    
    guard let fileURL = getFileURL(usingSearchString: searchString) else {
      Log.error(TAG, "error: unable to get file URL")
      return nil
    }
    
    do {
      if FileManager.default.fileExists(atPath: fileURL.path) == false {
        print("No file stored for search string - \(searchString)")
        return nil
      }
      let savedData = try Data(contentsOf: fileURL)
      let savedResponse
      = try decoder.decode(Response.self, from: savedData)
      Log.verbose(TAG, "got saved movies")
      return savedResponse.movies
    } catch {
      Log.error(TAG, "Couldn't read file. - \(error)")
    }
    return nil
  }
  
  func write(response: Response, usingSearchString searchString: String) async {
    
    guard let fileURL = getFileURL(usingSearchString: searchString) else {
      Log.error(TAG, "error: unable to get file URL")
      return
    }
    
    do {
      let data = try encoder.encode(response)
      try data.write(to: fileURL)
      Log.verbose(TAG, "Succesfully wrote to \(fileURL)")
    } catch {
      Log.error(TAG, error)
    }
    
    deleteOldFiles()
  }
  
  private func getFileURL(usingSearchString searchString: String) -> URL? {
    let fileURLs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    guard fileURLs.count > 0 else {
      return nil
    }
    let directoryURL = fileURLs.first
    return URL(fileURLWithPath: "\(searchString).dat", relativeTo: directoryURL)
  }
  
  private func deleteOldFiles() {
    let fileURLs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    guard fileURLs.count > 0 else {
      return
    }
    guard let directoryURL = fileURLs.first else { return }
    do {
      let directoryContents = try FileManager.default.contentsOfDirectory(
        at: directoryURL,
        includingPropertiesForKeys: [.creationDateKey]
      )
      
      for url in directoryContents {
        let creationDate = try url.resourceValues(forKeys:[.creationDateKey])
        Log.verbose(TAG, "\(url) creationDate = \(creationDate)")
      }
      
      
      var sortedDirectoryContents = directoryContents.sorted {
        do {
          if let creationDateFirst = try $0.resourceValues(forKeys:[.creationDateKey]).allValues[.creationDateKey] as? Date,
             let creationDateSecond = try $1.resourceValues(forKeys:[.creationDateKey]).allValues[.creationDateKey] as? Date {
            return creationDateFirst > creationDateSecond
          }
        } catch {
          Log.error(TAG, "getting creation dates failed")
        }
        Log.error(TAG, "unable to get creation dates")
        return false
      }

      while sortedDirectoryContents.count > DataStore.storedSearchResultsLimit {
        let removed = sortedDirectoryContents.removeLast()
        try FileManager.default.removeItem(at: removed)
      }
    } catch {
      Log.error(TAG, error)
    }
  }
}


