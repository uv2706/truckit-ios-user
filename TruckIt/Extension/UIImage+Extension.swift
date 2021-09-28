//
//  UIImage+extension.swift
//  BaseProj
//
//  Copyright © 2018 hb. All rights reserved.
//

import Foundation
import UIKit


extension UIImage {

    /// Compress the size of Image
    ///
    /// - Parameters:
    ///   - size: Height and Width of the required Image
    ///   - quality: Quality of Image
    /// - Returns: Returns the image of appropriate size and quality
    func compress(size: CGSize = CGSize(width: 1000, height: 1000), quality: CGFloat = 0.60) -> UIImage {
        var actualHeight = self.size.height
        var actualWidth = self.size.width
        let maxHeight:CGFloat = size.height
        let maxWidth:CGFloat = size.width
        var imgRatio = actualWidth/actualHeight
        let maxRatio = maxWidth/maxHeight

        if actualHeight > maxHeight || actualWidth > maxWidth {
            if imgRatio < maxRatio {
                imgRatio = maxHeight / actualHeight
                actualWidth = imgRatio * actualWidth
                actualHeight = maxHeight
            } else if imgRatio > maxRatio {
                imgRatio = maxWidth / actualWidth
                actualHeight = imgRatio * actualHeight
                actualWidth = maxWidth
            } else {
                actualHeight = maxHeight
                actualWidth = maxWidth
            }
        } else {
            actualHeight = maxHeight
            actualWidth = maxWidth
        }

        let rect = CGRect(x: 0, y: 0, width: actualWidth, height: actualHeight)
        UIGraphicsBeginImageContext(rect.size)
        self.draw(in: rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        let imgData = img!.jpegData( compressionQuality: quality)
        UIGraphicsEndImageContext()
        return UIImage(data: imgData!, scale: self.scale)!
    }


    /// Create thumb size of the big image
    ///
    /// - Parameters:
    ///   - size: Provide the height and with of the required image
    ///   - quality: Provide the quality of the image
    /// - Returns: Returns the thumb image
    func thumb(size: CGSize = CGSize(width: 300, height: 180), quality: CGFloat = 0.4) -> UIImage {
        return compress(size: size)
    }

    
    
     /// Compress image to desired size
       ///
       /// - Parameter expectedSizeInMb: Expected size in MB
       /// - Returns: Returns the image
       func compressTo(_ expectedSizeInMb:Double) -> Data? {
           let sizeInBytes = expectedSizeInMb * 1024 * 1024
           var needCompress:Bool = true
           var imgData:Data?
           var compressingValue:CGFloat = 1.0
           while (needCompress && compressingValue > 0.0) {
               if let data:Data = self.jpegData(compressionQuality: compressingValue) {
                   imgData = data
                   if data.count < Int(sizeInBytes) {
                       needCompress = false
                   } else {
                       compressingValue -= 0.1
                   }
               }
           }
           
           if needCompress {
               compressingValue = 0.1
               
               while (needCompress && compressingValue > 0.0) {
                   if let data:Data = self.jpegData(compressionQuality: compressingValue) {
                       imgData = data
                       if data.count < Int(sizeInBytes) {
                           needCompress = false
                       } else {
                           compressingValue -= 0.02
                       }
                   }
               }
           }
           
           if let data = imgData {
                   return data
           }
           return nil
       }
    
    /// Get Image with color
    ///
    /// - Parameters:
    ///   - color: Color of the Image
    ///   - size: Size Of the Image
    /// - Returns: UIImage object with color specified
    class func getImageWithColor(color: UIColor, size: CGSize) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    
    func makeRoundedImage( radius: CGFloat,viewSize:CGSize) -> UIImage {
        let imageLayer = CALayer()
        imageLayer.frame = CGRect(x: 0, y: 0, width: viewSize.width, height: viewSize.height)
        imageLayer.contents = self.cgImage
        
        imageLayer.masksToBounds = true
        imageLayer.cornerRadius = CGFloat(radius)
        imageLayer.backgroundColor = UIColor.clear.cgColor
        
        UIGraphicsBeginImageContextWithOptions(viewSize, false, UIScreen.main.scale)
        imageLayer.render(in: UIGraphicsGetCurrentContext()!)
        let roundedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return roundedImage!
    }
    
    
    convenience init(view: UIView) {
        
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.isOpaque, UIScreen.main.scale)
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: false)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.init(cgImage: (image?.cgImage)!)
        
    }
    
    func gradientImageWithBounds(bounds: CGRect, colors: [CGColor]) -> UIImage {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = colors
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        UIGraphicsBeginImageContext(gradientLayer.bounds.size)
        gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
}

