//
//  ReqResUserTableViewCell.swift
//  IMDB Movies
//
//  Created by Akshay Bhandary on 7/1/22.
//

import Foundation
import UIKit

@MainActor class MovieTableViewCell: UITableViewCell {
  var titleLabel: UILabel!
  var descriptionLabel: UILabel!
  var movieImage: UIImageView!
  var vStack: UIStackView!
  
  static let cellReuseIdentifier = "com.reqres.movie"
  
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
      movieImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10.0),
      movieImage.widthAnchor.constraint(equalTo: movieImage.heightAnchor)
    ])
    
    // name label constraints
    constraints.append(contentsOf:[
      vStack.topAnchor.constraint(equalTo: self.topAnchor, constant: 10.0),
      vStack.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10.0),
      vStack.leadingAnchor.constraint(equalTo: movieImage.trailingAnchor, constant: 20.0),
      vStack.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 5.0)
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
    
    titleLabel = UILabel()
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
  //  titleLabel.backgroundColor = UIColor.random()
    vStack.addArrangedSubview(titleLabel)
    
    descriptionLabel = UILabel()
    descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
    descriptionLabel.textColor = UIColor.darkGray
    vStack.addArrangedSubview(descriptionLabel)

    self.addSubview(vStack)
  }
}
