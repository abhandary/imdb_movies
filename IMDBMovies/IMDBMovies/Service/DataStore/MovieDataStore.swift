//
//  ReqResDataStore.swift
//  IMDB Movies
//
//  Created by Akshay Bhandary on 7/1/22.
//

import Foundation

private let TAG = "DataStore"

final class MovieDataStore: MovieDataStoreProtocol {
  
  static private let storedSearchResultsLimit = 100
  
  let encoder = PropertyListEncoder()
  let decoder = PropertyListDecoder()
  let fileManager: FileManagerProtocol
  
  init(fileManager: FileManagerProtocol = FileManager.default) {
    self.fileManager = fileManager
    encoder.outputFormat = .binary
  }
  
  func fetchMovies(usingSearchString searchString: String, completion: @escaping MovieDataStoreResultCompletion) {
    
    guard let fileURL = getFileURL(usingSearchString: searchString) else {
      Log.error(TAG, "error: unable to get file URL")
      completion(.failure(.fileURLCreationError))
      return
    }
    
    do {
      if self.fileManager.fileExists(atPath: fileURL.path) == false {
        Log.verbose(TAG, "No file stored for search string")
        completion(.failure(.noStoredData))
        return
      }
      let savedData = try Data(contentsOf: fileURL)
      let savedResponse
      = try decoder.decode(Response.self, from: savedData)
      Log.verbose(TAG, "got saved movies")
      completion(.success(savedResponse.movies))
      return
    } catch {
      Log.error(TAG, "Couldn't read file. - \(error)")
      completion(.failure(.fileReadError))
    }
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
    let fileURLs = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
    guard fileURLs.count > 0 else {
      return nil
    }
    let directoryURL = fileURLs.first
    return URL(fileURLWithPath: "\(searchString).dat", relativeTo: directoryURL)
  }
  
  private func deleteOldFiles() {
    let fileURLs = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
    guard fileURLs.count > 0 else {
      return
    }
    guard let directoryURL = fileURLs.first else { return }
    do {
      let directoryContents = try fileManager.contentsOfDirectory(
        at: directoryURL,
        includingPropertiesForKeys: [.creationDateKey],
        options: .skipsHiddenFiles
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

      while sortedDirectoryContents.count > MovieDataStore.storedSearchResultsLimit {
        let removed = sortedDirectoryContents.removeLast()
        try fileManager.removeItem(at: removed)
      }
    } catch {
      Log.error(TAG, error)
    }
  }
}


