//
//  FileManagerProtocol.swift
//  IMDBMovies
//
//  Created by Akshay Bhandary on 9/10/22.
//

import Foundation

protocol FileManagerProtocol {
  func fileExists(atPath path: String) -> Bool
  func contents(atPath path: String) -> Data?
  func urls(for directory: FileManager.SearchPathDirectory, in domainMask: FileManager.SearchPathDomainMask) -> [URL]
  func contentsOfDirectory(at url: URL, includingPropertiesForKeys keys: [URLResourceKey]?, options mask: FileManager.DirectoryEnumerationOptions) throws -> [URL]
  func removeItem(at URL: URL) throws
}

extension FileManager: FileManagerProtocol {}
