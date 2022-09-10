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
  let repository: MovieRepositoryProtocol
  
  var queryTask: Task<Optional<()>, Never>?
  
  @Published @MainActor var movies:[Movie] = []
  @Published @MainActor var searchString: String = ""
  
  init(repository: MovieRepositoryProtocol) {
    self.repository = repository
    
    $searchString
      .receive(on: RunLoop.main)
      .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
      .sink { keywords in self.queryForMovies(keywords: keywords)
      }.store(in: &cancellables)
  }
  
  @MainActor func fetchByID(id: String) -> Movie? {
    return self.movies.first { $0.id == id }
  }
  
  func queryForMovies(keywords: String) {
      Task {
        self.queryForMoviesAsync(keywords: keywords)
      }
  }
  
  func queryForMoviesAsync(keywords: String)  {
    
    Log.verbose(TAG,"running query for keywords - \(keywords)")
    
    self.repository.fetchMovies(usingSearchString: keywords) { result in
      switch (result) {
      case .failure(let error):
        Log.error(TAG, error)
      case .success(let movies):
        DispatchQueue.main.async {
          self.movies = movies
        }
      }
    }
  }
}
