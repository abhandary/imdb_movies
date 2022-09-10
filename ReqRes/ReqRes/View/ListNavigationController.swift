//
//  ListNavigationController.swift
//  IMDB Movies
//
//  Created by Akshay Bhandary on 7/2/22.
//

import Foundation
import UIKit

class ListNavigationController : UINavigationController {
  // This is also necessary when extending the superclass.
  required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }
  
  init() {
    super.init(nibName: nil, bundle: nil)
  }
}
