//
//  AppDelegate.swift
//  ReqRes
//
//  Created by Akshay Bhandary on 7/1/22.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
    window = UIWindow(frame: UIScreen.main.bounds)
    let viewModel = MoviesViewModel(networkLoader: NetworkLoader(), dataStorage: DataStore())
    let tableViewController = MoviesTableViewController(viewModel: viewModel, assetStore: AssetStore())
    let navController =  ListNavigationController()
    navController.viewControllers = [tableViewController]
    window?.rootViewController = navController
    window?.makeKeyAndVisible()
    return true
  }
}

