//
//  ImageFilteration.swift
//  IMDB Movies
//
//  Created by Akshay Bhandary on 7/2/22.
//

import Foundation
import UIKit

class ImageFilterationOperation: Operation {
  let inputPhotoRecord: PhotoRecord
  var resultPhotoRecord: PhotoRecord
  
  init(_ photoRecord: PhotoRecord) {
    self.inputPhotoRecord = photoRecord
    self.resultPhotoRecord =
      PhotoRecord(url: photoRecord.url,
                  state: .failed,
                  image: UIImage(named: "Failed"))
  }
  
  override func main () {
    if isCancelled {
      return
    }
    
    guard inputPhotoRecord.state == .downloaded else {
      print("ImageFilterationOperation: called while photo is not in downloaded state")
      return
    }
    
    if let image = inputPhotoRecord.image,
       let filteredImage = applySepiaFilter(image) {
      resultPhotoRecord
        = PhotoRecord(url: inputPhotoRecord.url,
                      state: inputPhotoRecord.state,
                      image: filteredImage)
    }
  }
  
  func applySepiaFilter(_ image: UIImage) -> UIImage? {
    guard let data = image.pngData() else { return nil }
    let inputImage = CIImage(data: data)
    
    if isCancelled {
      return nil
    }
    
    let context = CIContext(options: nil)
    
    guard let filter = CIFilter(name: "CISepiaTone") else { return nil }
    filter.setValue(inputImage, forKey: kCIInputImageKey)
    filter.setValue(0.8, forKey: "inputIntensity")
    
    if self.isCancelled {
      return nil
    }
    
    guard
      let outputImage = filter.outputImage,
      let outImage = context.createCGImage(outputImage, from: outputImage.extent)
    else {
      print("ImageFilterationOperation: creation of CGImage failed")
      return nil
    }
    
    return UIImage(cgImage: outImage)
  }
}
