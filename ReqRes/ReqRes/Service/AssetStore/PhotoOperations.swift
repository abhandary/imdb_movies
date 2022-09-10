//
//  PhotoOperations.swift
//  IMDB Movies
//
//  Created by Akshay Bhandary on 7/2/22.
//

import Foundation

protocol PhotoOperationsDelegate: AnyObject {
  func downloadComplete(forIndexPath: IndexPath, photoRecord: PhotoRecord)
  func filterationComplete(forIndexPath: IndexPath, photoRecord: PhotoRecord)
}

actor PhotoOperations {
  
  @MainActor weak var photoOperationsDelegate: PhotoOperationsDelegate?
  
  lazy var downloadOperationsInProgress: [IndexPath: Operation] = [:]
  lazy var filtrationOperationsInProgress: [IndexPath: Operation] = [:]
  lazy var operationQueue: OperationQueue = {
    var queue = OperationQueue()
    queue.name = "Photo Operations queue"
    queue.maxConcurrentOperationCount = 10
    return queue
  }()
  
  func suspendAllOperations() {
    operationQueue.isSuspended = true
  }
  
  func resumeAllOperations() {
    operationQueue.isSuspended = false
  }

  func startDownload(for photoRecord: PhotoRecord, at indexPath: IndexPath) async {
    guard downloadOperationsInProgress[indexPath] == nil else {
      return
    }
    let downloadOperation = startDownloadInternal(for: photoRecord, at: indexPath)
    operationQueue.addOperation(downloadOperation)
  }
  
  func startDownloadAndFilter(for photoRecord: PhotoRecord, at indexPath: IndexPath) async {
    
    guard photoRecord.url != nil else {
      print("got a photo record with nil url")
      return
    }
    
    guard downloadOperationsInProgress[indexPath] == nil &&
            filtrationOperationsInProgress[indexPath] == nil else {
      print("download already in progress for index path - \(indexPath)")
      return
    }
    
    let downloadOperation = startDownloadInternal(for: photoRecord, at: indexPath)
    let filterationOperation = startDownloadInternal(for: photoRecord, at: indexPath)
    filterationOperation.addDependency(downloadOperation)
    operationQueue.addOperation(filterationOperation)
    operationQueue.addOperation(downloadOperation)
  }
  
  func loadImagesForIndexPaths(paths: [IndexPath]) {
    
      //2
      var allPendingOperations = Set(downloadOperationsInProgress.keys)
      allPendingOperations.formUnion(filtrationOperationsInProgress.keys)
      
      //3
      var toBeCancelled = allPendingOperations
      let visiblePaths = Set(paths)
      toBeCancelled.subtract(visiblePaths)
      
      //4
      var toBeStarted = visiblePaths
      toBeStarted.subtract(allPendingOperations)
      
      // 5
      for indexPath in toBeCancelled {
        if let pendingDownload = downloadOperationsInProgress[indexPath] {
          pendingDownload.cancel()
        }
        
        downloadOperationsInProgress.removeValue(forKey: indexPath)
        if let pendingFiltration = filtrationOperationsInProgress[indexPath] {
          pendingFiltration.cancel()
        }
        
        filtrationOperationsInProgress.removeValue(forKey: indexPath)
      }
      
      // 6
    /*
      for indexPath in toBeStarted {
        let recordToProcess = photos[indexPath.row]
        startOperations(for: recordToProcess, at: indexPath)
      }
     */
  }
  
  
  private func startDownloadInternal(for photoRecord: PhotoRecord, at indexPath: IndexPath) -> Operation {
    
    //1 create download operation
    let downloader = ImageDownloaderOperation(photoRecord)
    
    //2 on completion, stop tracking it and notify caller
    downloader.completionBlock = {
      if downloader.isCancelled {
        return
      }
      
      self.downloadOperationsInProgress.removeValue(forKey: indexPath)
      
      DispatchQueue.main.async { [weak self] in
        self?.photoOperationsDelegate?.downloadComplete(forIndexPath: indexPath,
                                                        photoRecord: downloader.resultPhotoRecord)
      }
    }
    
    //3 track the operation
    downloadOperationsInProgress[indexPath] = downloader
    
    return downloader
  }
  
  private func startFilterationInternal(for photoRecord: PhotoRecord, at indexPath: IndexPath) -> Operation {
    
    //1 create filteration operation
    let filtration = ImageFilterationOperation(photoRecord)
    
    //2 on completion, stop tracking it and notify caller
    filtration.completionBlock = {
      if filtration.isCancelled {
        return
      }
      self.filtrationOperationsInProgress.removeValue(forKey: indexPath)
      DispatchQueue.main.async { [weak self] in
        self?.photoOperationsDelegate?.filterationComplete(forIndexPath: indexPath,
                                                           photoRecord: filtration.resultPhotoRecord)
      }
    }
    
    //3 track the operation
    filtrationOperationsInProgress[indexPath] = filtration
    
    return filtration
  }
}
