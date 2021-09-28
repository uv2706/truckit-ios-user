//
//  UIImageView+Extension.swift
//  PickUpUser
//
//  Created by hb on 06/06/19.
//  Copyright © 2019 hb. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher


extension UIImageView {
    func setImage(with url: String?, placeHolder: UIImage? = nil, completed: (() -> Void)? = nil) {
        if let urlString = url {
            let url = URL(string: urlString)
            //         self.kf.indicatorType = .activity
            self.kf.setImage(with: url, placeholder: placeHolder, options: [
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ], progressBlock: nil) { (result) in
                completed?()
            }
            
           
            
        } else {
            self.image = placeHolder
        }
    
        
      
    }
    
    func changePngColorTo(color: UIColor){
        guard let image =  self.image else {return}
        self.image = image.withRenderingMode(.alwaysTemplate)
        self.tintColor = color
    }
}
