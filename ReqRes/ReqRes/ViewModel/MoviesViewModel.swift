//
//  ReqResUsersViewModel.swift
//  IMDB Movies
//
//  Created by Akshay Bhandary on 7/1/22.
//

import Foundation
import UIKit
import Combine

private let TAG = "MoviesViewModel"

class MoviesViewModel {
  
  var cancellables: Set<AnyCancellable> = []
  var networkLoader: NetworkLoaderProtocol!
  var dataStorage: DataStoreProtocol!
  
  var queryTask: Task<Optional<()>, Never>?
  
  @MainActor var movies:[Movie] = []
  @MainActor var diffableDataSource: UITableViewDiffableDataSource<MoviesTableSection, Movie.ID>?
  @Published @MainActor var searchString: String = ""
  
  init(networkLoader: NetworkLoaderProtocol,
       dataStorage: DataStoreProtocol) {
    self.networkLoader = networkLoader
    self.dataStorage = dataStorage
    
    $searchString
      .receive(on: RunLoop.main)
      .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
      .sink { keywords in self.queryForMovies(keywords: keywords)
      }.store(in: &cancellables)
  }
  
  @MainActor func fetchByID(id: String) -> Movie? {
    return self.movies.first { $0.id == id }
  }
  
  func setMovieItemNeedsUpdate(id: String) {
    Task {
      await self.setMovieItemNeedsUpdateAsync(id:id)
    }
  }
  
  private func setMovieItemNeedsUpdateAsync(id: String) async {
    if var snapshot = await self.diffableDataSource?.snapshot() {
      snapshot.reconfigureItems([id])
      await self.diffableDataSource?.apply(snapshot, animatingDifferences: true)
    }
  }
  
  func queryForMovies(keywords: String) {
    queryTask?.cancel()
    queryTask = Task { [weak self] in
      await self?.queryForMoviesAsync(keywords: keywords)
    }
  }
  
  func queryForMoviesAsync(keywords: String) async {
    
    // fetch from data store if present
    await queryFromDataStoreAndUpdate(keywords: keywords)
    
    Log.verbose(TAG,"running query for keywords - \(keywords)")
    
    // async fetch from network and update and notify
    if let response = await networkLoader.queryForMovies(usingSearchString: keywords) {
      Log.verbose(TAG,"writing network response to data store")
      await dataStorage.write(response: response, usingSearchString: keywords)
      await queryFromDataStoreAndUpdate(keywords: keywords)
    } else {
      Log.error(TAG,"got back empty response for keywords - \(keywords)")
    }
  }
  
  private func queryFromDataStoreAndUpdate(keywords: String) async {
    
    Log.verbose(TAG, "querying data store and updating for keywords - \(keywords)")
    
    if let movies = await dataStorage.fetchMovies(usingSearchString: keywords) {
      await MainActor.run {
        self.movies = movies
      }
      var snapshot = NSDiffableDataSourceSnapshot<MoviesTableSection, Movie.ID>()
      snapshot.appendSections([.main])
      let movieIDs = movies.map { $0.id }
      snapshot.appendItems(movieIDs, toSection:.main)
      await self.diffableDataSource?.apply(snapshot, animatingDifferences: true)
    }
  }
}
