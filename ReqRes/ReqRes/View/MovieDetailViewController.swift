//
//  MovieDetailViewController.swift
//  IMDB Movies
//
//  Created by Akshay Bhandary on 7/2/22.
//

import Foundation
import UIKit

private let TAG = "MovieDetailViewController"

@MainActor class MovieDetailViewController: UIViewController {
  
  var assetStore: AssetStore!
  var movie: Movie!
  var stackView: UIStackView!
  
  let movieImage = UIImageView()
  
  init(movie: Movie, assetStore: AssetStore) {
    self.movie = movie
    self.assetStore = assetStore
    stackView = UIStackView()
    super.init(nibName: nil, bundle: nil)
  }

  override func viewDidLoad() {
    
    setMovieImage(urlString: movie.image)

    // setup stack views
    stackView.axis = .vertical
    stackView.distribution = .fill
    stackView.alignment = .fill
    stackView.spacing = 50
    
    stackView.addArrangedSubview(movieImage)
    stackView.addArrangedSubview(getHozintalStackView(staticPrefix: "Title:", labelString: movie.title))
    stackView.addArrangedSubview(getHozintalStackView(staticPrefix: "Description", labelString: movie.resultDescription))
    
    self.view.addSubview(stackView)
    stackView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate(getConstraints())
  }
  
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
  
  private func getHozintalStackView(staticPrefix: String, labelString: String) -> UIStackView {
    let hStackView = UIStackView()
    hStackView.axis = .horizontal
    hStackView.alignment = .fill
    hStackView.distribution = .fill
    hStackView.spacing = 10
    hStackView.translatesAutoresizingMaskIntoConstraints = false
    
    let prefixLabel = UILabel()
    prefixLabel.translatesAutoresizingMaskIntoConstraints = false
    prefixLabel.text = staticPrefix
    prefixLabel.font = .boldSystemFont(ofSize: 20)
    prefixLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    hStackView.addArrangedSubview(prefixLabel)
    
    let label = UILabel()
    label.text = labelString
    label.translatesAutoresizingMaskIntoConstraints = false
    label.setContentHuggingPriority(.defaultLow, for: .horizontal)
    hStackView.addArrangedSubview(label)
    
    return hStackView
  }
  
  private func setMovieImage(urlString: String) {
    let asset = self.assetStore.fetchAsset(url: URL(string: urlString))
    guard let data = asset.data else {
      Log.error(TAG, "got an empty data for asset url string - \(urlString)")
      return 
    }
    movieImage.image = UIImage(data: data)
    movieImage.layer.cornerRadius = 10.0
    movieImage.clipsToBounds = true
  }
  
  private func getConstraints() -> [NSLayoutConstraint] {
    return [
      stackView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
      stackView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
      stackView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
      movieImage.widthAnchor.constraint(equalTo: movieImage.heightAnchor),
    ]
  }
}
