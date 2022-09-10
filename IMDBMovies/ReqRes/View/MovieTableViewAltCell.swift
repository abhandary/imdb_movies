//
//  MovieTableViewAltCell.swift
//  IMDB Movies
//
//  Created by Akshay Bhandary on 7/1/22.
//

import Foundation
import UIKit

private let TAG = "MovieTableViewAltCell"

@MainActor class MovieTableViewAltCell: UITableViewCell {
  
  var titleLabel: UILabel!
  var descriptionLabel: UILabel!
  var movieImage: UIImageView!
  var vStack: UIStackView!
  
  var movie: Movie?
  
  static let cellReuseIdentifier = "com.imdb.movie"
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    setupProfilePic()
    setupTitleDescriptionVStack()
    
    NSLayoutConstraint.activate(staticConstraints())
  }
  
  private func staticConstraints() -> [NSLayoutConstraint] {
    var constraints: [NSLayoutConstraint] = []
    
    // profile image constraints
    constraints.append(contentsOf: [
      movieImage.topAnchor.constraint(equalTo: self.topAnchor, constant: 10.0),
      movieImage.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10.0),
      movieImage.trailingAnchor.constraint(equalTo: self.trailingAnchor , constant: -10.0),
      movieImage.widthAnchor.constraint(equalTo: movieImage.heightAnchor)
    ])
    
    // name label constraints
    constraints.append(contentsOf:[
      vStack.topAnchor.constraint(equalTo: self.topAnchor, constant: 10.0),
      vStack.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10.0),
      vStack.trailingAnchor.constraint(equalTo: movieImage.leadingAnchor, constant: -10.0),
      vStack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10.0)
    ])
    
    return constraints
  }
  
  private func setupProfilePic() {
    movieImage = UIImageView()
    
    // setup corners
    movieImage.layer.cornerRadius = 10.0
    movieImage.clipsToBounds = true
    movieImage.translatesAutoresizingMaskIntoConstraints = false
    
    // add border
    movieImage.layer.borderWidth = 1.0
    movieImage.layer.borderColor = UIColor.gray.cgColor
    
    self.addSubview(movieImage)
  }
  
  private func setupTitleDescriptionVStack() {
    
    vStack = UIStackView()
    vStack.axis = .vertical
    vStack.distribution = .fill
    vStack.alignment = .fill
  //  vStack.backgroundColor = UIColor.random()
    vStack.translatesAutoresizingMaskIntoConstraints = false
    vStack.spacing = 5.0
    
    titleLabel = UILabel()
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
    titleLabel.numberOfLines = 2
   // titleLabel.backgroundColor = UIColor.random()
    vStack.addArrangedSubview(titleLabel)
    
    descriptionLabel = UILabel()
    descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
    descriptionLabel.numberOfLines = 2
    descriptionLabel.lineBreakMode = .byTruncatingTail
    descriptionLabel.textColor = UIColor.darkGray
 //   descriptionLabel.backgroundColor = UIColor.random()
    vStack.addArrangedSubview(descriptionLabel)

    self.addSubview(vStack)
  }
  
  func setup(withMovie movie: Movie, assetStore: AssetStore) {
    
    self.movie = movie
    
    let movieImageURL = URL(string: movie.image)
    if movieImageURL == nil {
      Log.error(TAG, "couldn't get URL for movie url string - \(movie.image)")
      // non fatal error, continue with showing a placeholder
    }

    self.titleLabel.text = movie.title
    self.descriptionLabel.text = movie.resultDescription
    let asset = assetStore.fetchAsset(url: movieImageURL)
    
    if asset.state == .placeholder {
      self.movieImage.image = UIImage(named: "Placeholder")
      assetStore.downloadAsset(url: movieImageURL) { [weak self] asset in
        DispatchQueue.main.async {
          self?.updateIfMovieIsSame(asset: asset)
        }
      }
    } else if let imageData = asset.data {
      self.movieImage.image = UIImage(data: imageData)
    }
  }
  
  private func updateIfMovieIsSame(asset: Asset) {
    
    guard let assetURL = asset.url,
            let movie = movie,
            let  movieImageURL = URL(string: movie.image),
            let imageData = asset.data else {
      Log.error(TAG, "Unable to update asset")
      return
    }
    
    if assetURL == movieImageURL {
      self.movieImage.image = UIImage(data: imageData)
    }
  }
}
