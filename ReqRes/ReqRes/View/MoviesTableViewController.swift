//
//  MoviesTableViewController.swift
//  IMDB Movies
//
//  Created by Akshay Bhandary on 7/1/22.
//

import UIKit
import Combine

private let MOVIE_CELL_HOW_HEIGHT = 100.0
private let TAG = "MoviesTableViewController"

@MainActor class MoviesTableViewController: UIViewController  {
  
  @Published var keyStroke: String = ""
  var cancellables: Set<AnyCancellable> = []
  
  let searchBar: UISearchBar!
  let tableView: UITableView!
  let viewModel: MoviesViewModel!
  let assetStore: AssetStore!
  
  init(viewModel: MoviesViewModel, assetStore: AssetStore) {
    self.viewModel = viewModel
    self.assetStore = assetStore
    self.tableView = UITableView()
    self.searchBar = UISearchBar()
    super.init(nibName: nil, bundle: nil)
  }
  
  // This is also necessary when extending the superclass.
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()

    setupSearchBar()
    setupTableView()
    setupObservers()
    setupTableViewDataSource()
    
    NSLayoutConstraint.activate(staticConstraints())
  }
  
  private func staticConstraints() -> [NSLayoutConstraint] {
    var constraints: [NSLayoutConstraint] = []
    
    // profile image constraints
    constraints.append(contentsOf: [
      searchBar.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
      searchBar.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
      searchBar.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
    ])
    
    // name label constraints
    constraints.append(contentsOf:[
      tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
      tableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
      tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
    ])
    
    return constraints
  }
}

// MARK: - UITableView Delegate
extension MoviesTableViewController: UITableViewDelegate {
  
  // delegate methods
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    print(indexPath)
    let movie = viewModel.movies[indexPath.row]
    let detailVC = MovieDetailViewController(movie:movie, assetStore: self.assetStore)
    detailVC.view.backgroundColor = .white
    self.navigationController?.pushViewController(detailVC, animated: true)
  }
  
  private func setupTableView() {
    self.tableView.delegate = self
    self.tableView.register(MovieTableViewAltCell.self,
                            forCellReuseIdentifier: MovieTableViewAltCell.cellReuseIdentifier)
    self.tableView.rowHeight = MOVIE_CELL_HOW_HEIGHT
    self.tableView.translatesAutoresizingMaskIntoConstraints = false
    self.view.addSubview(self.tableView)
  }
  
  private func setupSearchBar() {
    self.searchBar.delegate = self
    self.searchBar.translatesAutoresizingMaskIntoConstraints = false
    self.searchBar.prompt = "Enter a movie name to search"
    self.view.addSubview(searchBar)
  }
}

// MARK: - UISearchBar Delegate
extension MoviesTableViewController: UISearchBarDelegate
{
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
  {
    self.keyStroke = searchText
  }
  
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    self.keyStroke = ""
  }
}

// MARK: - table view data source
extension MoviesTableViewController
{
  func setupTableViewDataSource() {
    
    // diffable datasource
    viewModel.diffableDataSource
    = UITableViewDiffableDataSource<MoviesTableSection, Movie.ID>(tableView: tableView) {
        (tableView, indexPath, movieID) -> UITableViewCell? in
      let movie = self.viewModel.fetchByID(id: movieID)
      guard let movie = movie else {
        fatalError("unable to find movie object that matches id - \(movieID)")
      }
      guard
        let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewAltCell.cellReuseIdentifier, for: indexPath) as? MovieTableViewAltCell
      else {
        fatalError("unable to dequeue cell")
      }
      
      cell.setup(withMovie: movie, assetStore: self.assetStore)
      
      return cell
    }
  }
  
  private func setup(_ cell: MovieTableViewAltCell, withMovie movie: Movie) {
    let movieImageURL = URL(string: movie.image)
    if movieImageURL == nil {
      Log.error(TAG, "couldn't get URL for movie url string - \(movie.image)")
      // non fatal error, continue with showing a placeholder
    }
    let asset = self.assetStore.fetchAsset(url: movieImageURL)
    cell.titleLabel.text = movie.title
    cell.descriptionLabel.text = movie.resultDescription
    if asset.state == .placeholder {
      cell.movieImage.image = UIImage(named: "Placeholder")
      self.assetStore.downloadAsset(url: movieImageURL) { [weak self] asset in
        // reconfigure the item instead of the cell directly as the cell may
        // have been re-used at this point
        self?.viewModel.setMovieItemNeedsUpdate(id: movie.id)
      }
    } else if let imageData = asset.data {
      cell.movieImage.image = UIImage(data: imageData)
    }
  }
}



//MARK: - Search bar text observer
extension MoviesTableViewController
{
  func setupObservers()
  {
    // MONITOR search bar textfield keystrokes
    $keyStroke
      .receive(on: RunLoop.main)
      .sink { (keywords) in
        print(keywords)
        self.viewModel.searchString = keywords
      }.store(in: &cancellables)
  }
}

