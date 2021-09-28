//
//  AppDelegate+Extension.swift
//  PickUpUser
//
//  Created by hb on 06/06/19.
//  Copyright © 2019 hb. All rights reserved.
//

import Foundation
import UIKit
import SwiftEntryKit

extension AppDelegate
{
    
    
    /// Show Indicator
    ///
    /// - Parameter isWindow: Set Yes if needs to be added on window
    func showIndicator(isWindow : Bool = false)
    {
        let aStoryboard = UIStoryboard.init(name: "Loader", bundle: nil)
        let aVCObj = aStoryboard.instantiateViewController(withIdentifier: "LoaderVC") as! LoaderVC
        let aParent = AppConstants.appDelegate.window
        aVCObj.view.frame = UIScreen.main.bounds
        aVCObj.view.tag  = 10000
        aParent?.addSubview(aVCObj.view)
    }
    
    /// Hide Activity Indicator
    ///
    /// - Parameter isWindow: Set Yes is indicator is added on window
    func hideIndicator(isWindow : Bool = false)
    {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        let aParent = AppConstants.appDelegate.window
        for view in (aParent?.subviews)!
        {
            if view.tag == 10000
            {
                view.removeFromSuperview()
            }
        }
        
    }
    
    /// Show message below navigationbar
    ///
    /// - Parameters:
    ///   - message: Message to be displayed
    ///   - type: Type of Message
    func showTopMessage(message : String, type : NotificationType, displayDuraction: Double = 2)
    {
        var color = UIColor.gray
        
        if type == .Error
        {
            color = #colorLiteral(red: 0.846742928, green: 0.1176741496, blue: 0, alpha: 1)
        }
        else if type == .Success
        {
            color = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        }
        //
        
        var attributes = EKAttributes.topFloat
        attributes.entryBackground = .color(color: EKColor(color))
        attributes.popBehavior = .animated(animation: .init(translate: .init(duration: 0.3), scale: .init(from: 1, to: 0.7, duration: 0.7)))
        attributes.shadow = .active(with: .init(color: .black, opacity: 0.5, radius: 10, offset: .zero))
        attributes.statusBar = .dark
        attributes.scroll = .enabled(swipeable: true, pullbackAnimation: .jolt)
        attributes.positionConstraints.maxSize = .init(width: .constant(value: AppConstants.screenWidth), height: .intrinsic)
        attributes.displayDuration = displayDuraction
        
        let title = EKProperty.LabelContent(text: AppConstants.appName, style: .init(font: UIFont(name: "Montserrat-Bold", size: 17.0)!, color: .white))
        let description = EKProperty.LabelContent(text: message, style: .init(font:  UIFont(name: "Montserrat-Regular", size: 15.0)!, color: .white))
        //        let image = EKProperty.ImageContent(image: UIImage(named: imageName)!, size: CGSize(width: 35, height: 35))
        let simpleMessage = EKSimpleMessage(image: nil, title: title, description: description)
        let notificationMessage = EKNotificationMessage(simpleMessage: simpleMessage)
        
        let contentView = EKNotificationMessageView(with: notificationMessage)
        SwiftEntryKit.display(entry: contentView, using: attributes)
        
    }
    
}
