//
//  UIView+extension.swift
//
//  Copyright © 2017 hb. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAnalytics

extension UIView {
    /// Add Rounded corner
    ///
    /// - Parameter radius: Radius of the corners
	func setRoundCorner(radius:CGFloat) {
		self.layer.cornerRadius = radius
		self.layer.masksToBounds = true
	}
    
    /// Add Reounded corner with shadow
    ///
    /// - Parameter cornerRe: Radius of the corners
    func setCornerRadiusAndShadow(cornerRe: CGFloat){
        self.layer.cornerRadius = cornerRe
        self.setShadow()
    }
    
    /// Add shadow
    func setShadow() {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.2
        self.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.layer.shadowRadius = 2
    }
	
    /// Add Border to the View
    ///
    /// - Parameters:
    ///   - color: Color of the border
    ///   - size: Width of the border
	func setBorder(color:UIColor = UIColor.clear, size:CGFloat = 1) {
		self.layer.borderColor = color.cgColor
		self.layer.borderWidth = size
	}
	
    /// Set Rounded border along with Border Color
    ///
    /// - Parameters:
    ///   - radius: Radius of the corners
    ///   - color: Color of the border
    ///   - size: Width of the border
	func setRoundBorder(radius:CGFloat, color:UIColor = UIColor.clear, size:CGFloat = 1) {
		self.setRoundCorner(radius: radius)
		self.setBorder(color: color, size: size)
	}
	
    /// Method used to apply corner radius to speicific corners
    ///
    /// - Parameters:
    ///   - corners: Accepts the array of type UIRectCorner
    ///   - radius:Radius of the corners
    func roundCorners(corners:UIRectCorner, radius: CGFloat,bounds:CGRect = CGRect.zero) {
        
        let aApplyBound = bounds == CGRect.zero ? self.bounds : bounds
        
        let path = UIBezierPath(roundedRect:aApplyBound, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
    
    func setBorderWithCornerRadius(corners:UIRectCorner, radius: CGFloat, color borderColor: UIColor?, width borderWidth: CGFloat) {
        let rect: CGRect = bounds
        
        //Make round
        // Create the path for to make circle
        let maskPath = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        
        // Create the shape layer and set its path
        let maskLayer = CAShapeLayer()
        
        maskLayer.frame = rect
        maskLayer.path = maskPath.cgPath
        
        // Set the newly created shape layer as the mask for the view's layer
        layer.mask = maskLayer
        
        //Give Border
        //Create path for border
        let borderPath = UIBezierPath(roundedRect: rect, byRoundingCorners:corners, cornerRadii: CGSize(width: radius, height: radius))
        
        // Create the shape layer and set its path
        let layerName = "ig_border_layer"
        
        var borderLayers =  layer.sublayers?.filter({ (sublayer) -> Bool in
            return sublayer.name == "layerName"
        })
        
        if borderLayers != nil && (borderLayers?.count)! > 0
        {
            var borderLayer = borderLayers![0] as! CAShapeLayer
            if borderLayer == nil {
                borderLayer = CAShapeLayer()
                borderLayer.name = layerName
                //Add this layer to give border.
                layer.addSublayer(borderLayer)
            }
            
            
            borderLayer.frame = rect
            borderLayer.path = borderPath.cgPath
            borderLayer.strokeColor = UIColor.white.cgColor
            borderLayer.fillColor = UIColor.clear.cgColor
            borderLayer.lineWidth = borderWidth
        }
        else
        {
            let borderLayer =  CAShapeLayer()
            borderLayer.name = layerName
            //Add this layer to give border.
            layer.addSublayer(borderLayer)
            borderLayer.frame = rect
            borderLayer.path = borderPath.cgPath
            borderLayer.strokeColor = UIColor.white.cgColor
            borderLayer.fillColor = UIColor.clear.cgColor
            borderLayer.lineWidth = borderWidth
        }
    }
    
    
   
    /// Add Shadow to the View to particular Position
    ///
    /// - Parameter position: Accepts the enum value shadowPosition to specify the position of the shadow
    func addViewShadowAtPosition( position:shadowPosition, height :CGFloat =  3.0, color:UIColor = UIColor.lightGray)
    {
        var aRect : CGRect!
        if position == .bottom
        {
            aRect = CGRect(x: 0, y: frame.size.height/2, width: frame.size.width, height: frame.size.height/2)
        }
        else if position == .top
        {
            aRect = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height/2)
        }
        else if position == .line
        {
            aRect = CGRect(x: 0, y: frame.size.height-2, width: frame.size.width, height: 2)
        }
        else
        {
            aRect = CGRect(x: -2, y: -2, width: frame.size.width + 2, height: frame.size.height + 2)
        }
        
        let shadowPath = UIBezierPath(rect: aRect)
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 1)
        layer.shadowOpacity = 0.5
        layer.shadowPath = shadowPath.cgPath
        layer.shadowRadius = 1.0
    }
    
    
    /// Add Circular shadow around view
    ///
    /// - Parameter radius: Radius of the shadow
    func addCircularShadow(_ radius:CGFloat)
    {
        let aRect = CGRect(x: 0, y: -2, width: frame.size.width + 2, height: frame.size.height + 2)
        let shadowPath = UIBezierPath(roundedRect: aRect , cornerRadius: radius)
        layer.masksToBounds = false
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        layer.shadowOpacity = 0.5
        layer.shadowPath = shadowPath.cgPath
        layer.shadowRadius = 1.0

    }
    
    func addOnePixelShadowWithColor( _ color : UIColor = UIColor.gray)
    {
        layer.shadowColor = color.cgColor
        layer.shadowOffset = CGSize(width: 1, height: 1)
        layer.shadowOpacity = 1.0
        layer.shadowRadius = 1.0
    }
    
    
}
