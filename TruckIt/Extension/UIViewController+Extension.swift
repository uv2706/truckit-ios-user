//
//  File.swift
//  TapATrade
//
//  Created by hb on 13/03/18.
//  Copyright © 2018 hb. All rights reserved.
//

import Foundation
import UIKit
import Photos
import SKPhotoBrowser
import MessageUI
import FirebaseAnalytics

extension UIViewController : SKPhotoBrowserDelegate {
    
    /// Show Alert in the ViewController
    ///
    /// - Parameters:
    ///   - message: Message to be displayed in the Alert
    ///   - okAction: Closure To do after user clicks OK
    func showSimpleAlert(message:String, okAction: (() -> Void)? = nil)   {
        let alertController = UIAlertController(title: AppConstants.appName, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { (action) in
            
            if let _ = okAction
            {
                okAction!()
            }
            
        }
        alertController.addAction(action)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    
    /// Show Alert in the ViewController
    ///
    /// - Parameters:
    ///   - message: Message to be displayed in the Alert
    ///   - okAction: Closure To do after user clicks OK
    ///   - cancelAction: Closure To do after user clicks Cancel
    func showLogoutAlert(message:String, okAction: (() -> Void )? = nil, cancelAction: (() -> Void)? = nil)   {
        let alertController = UIAlertController(title: AppConstants.appName, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Yes", style: .default) { (action) in
            
            if let _ = okAction
            {
                okAction!()
            }
            
        }
        
        let cancel = UIAlertAction(title: "No", style: .cancel) { (action) in
            
            if let _ = cancelAction
            {
                cancelAction!()
            }
            
        }
        alertController.addAction(cancel)
        alertController.addAction(okAction)
        
        
        self.present(alertController, animated: true, completion: nil)
    }
    /// Display Alert with options Yes or No
    ///
    /// - Parameters:
    ///   - msg: Message to be displayed in the alert
    ///   - ok: Text for Ok
    ///   - cancel: Text for cancel
    ///   - okAction:  Closure To do after user clicks OK
    ///   - cancelAction: Closure To do after user clicks Cancel
    func displayAlert( msg: String?, ok: String, cancel: String, okAction: (() -> Void)? = nil, cancelAction: (() -> Void)? = nil){
        
        let alertController = UIAlertController(title:  AppConstants.appName, message: msg, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: cancel, style: .cancel)
        { (action) in
            if let cancelAction = cancelAction {
                DispatchQueue.main.async(execute: {
                    cancelAction()
                })
            }
        }
        
        alertController.addAction(cancelAction)
        
        let OKAction = UIAlertAction(title: ok, style: .default)
        { (action) in
            if let okAction = okAction {
                DispatchQueue.main.async(execute: {
                    okAction()
                })
            }
        }
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    /// Call
    ///
    /// - Parameter phoneNumber: phoneNumber
    func callNumber(phoneNumber:String) {
        if !phoneNumber.isEmpty {
            let aNumber = phoneNumber.replacingOccurrences(of: " ", with: "")
            if let phoneCallURL:URL = URL(string:"tel://\(aNumber)") {
                let application:UIApplication = UIApplication.shared
                if (application.canOpenURL(phoneCallURL )) {
                    if #available(iOS 10, *) {
                        application.open(phoneCallURL , options: [:], completionHandler: nil)
                    } else {
                        application.openURL(phoneCallURL);
                    }
                }
            }
        }
    }
    
    public func getInfoButton(action : Selector, target : Any) -> UIBarButtonItem {
        let btnBar = UIButton(type: .custom)
        btnBar.setTitle("ⓘ", for: .normal)
        btnBar.titleLabel?.font = UIFont.systemFont(ofSize: 22,weight: .medium)
        btnBar.contentHorizontalAlignment = .center
        btnBar.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -10)
        btnBar.addTarget(target, action: action, for: .touchUpInside)
        btnBar.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        let barButton : UIBarButtonItem = UIBarButtonItem(customView: btnBar)
        return barButton
    }
    
    //topViewController function helps to find top most controller
    /// topViewController function helps to find top most controller
    ///
    /// - Parameter rootViewController: RootViewController of the window
    /// - Returns: TopView controller in the heirarchy
    class func topViewController(withRootViewController rootViewController: UIViewController) -> UIViewController {
        if (rootViewController is UITabBarController) {
            let tabBarController = (rootViewController as! UITabBarController)
            return self.topViewController(withRootViewController: tabBarController.selectedViewController!)
        }
        else if (rootViewController is UINavigationController) {
            let navigationController = (rootViewController as! UINavigationController)
            return self.topViewController(withRootViewController: navigationController.visibleViewController!)
        }
        else if (rootViewController.presentedViewController != nil) {
            let presentedViewController = rootViewController.presentedViewController
            return self.topViewController(withRootViewController: presentedViewController!)
        }
        else {
            return rootViewController
        }
    }

    /// Get Bar Button with image
    ///
    /// - Parameters:
    ///   - image: Image of the bar button
    ///   - selected_image: Selected Image of the bar button
    ///   - action: Action selector for the button
    ///   - target: Target for the button
    /// - Returns: Bar Button with image
    public func getButton(image : UIImage,selected_image: UIImage ,action : Selector, target : Any) -> UIBarButtonItem {
        let btnBar = UIButton(type: .custom)
        btnBar.setImage(image, for: .normal)
        btnBar.setImage(selected_image, for: .selected)
        btnBar.contentHorizontalAlignment = .center
        btnBar.imageEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
        btnBar.addTarget(target, action: action, for: .touchUpInside)
        btnBar.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        let barButton : UIBarButtonItem = UIBarButtonItem(customView: btnBar)
        return barButton
    }
    
    
    public func getOtherButton(image : UIImage,selected_image: UIImage ,action : Selector, target : Any) -> UIBarButtonItem {
        let btnBar = UIButton(type: .custom)
        btnBar.setImage(image, for: .normal)
        btnBar.setImage(selected_image, for: .selected)
        btnBar.contentHorizontalAlignment = .center
        btnBar.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -10)
        btnBar.addTarget(target, action: action, for: .touchUpInside)
        btnBar.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        let barButton : UIBarButtonItem = UIBarButtonItem(customView: btnBar)
        return barButton
    }
    
    public func getBadgeButton(image : UIImage,selected_image: UIImage ,action : Selector, target : Any, badgecount: String) -> UIBarButtonItem  {
        let notificationButton = SSBadgeButton()
        notificationButton.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        notificationButton.setImage(image, for: .normal)
        notificationButton.setImage(selected_image, for: .selected)
        notificationButton.contentHorizontalAlignment = .center
        notificationButton.addTarget(target, action: action, for: .touchUpInside)
        notificationButton.badgeEdgeInsets = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 15)
        notificationButton.badge = badgecount
        
        return UIBarButtonItem(customView: notificationButton)
    }
    /// Set the Left view in textField
    ///
    /// - Parameters:
    ///   - image: UIimage For Left view
    ///   - textField: UITextField
    //#colorLiteral(red: 0.5058823529, green: 0.5058823529, blue: 0.5058823529, alpha: 1))
    func setLeftViewButtonForTextField(image: UIImage,textField: UITextField, tintColor: UIColor = #colorLiteral(red: 0.5058823529, green: 0.5058823529, blue: 0.5058823529, alpha: 1)) {
        
        let imgView = UIImageView(frame: CGRect(x: 20, y: 0, width: 40, height: 45))
        imgView.contentMode = .center
        imgView.image = image
        imgView.changePngColorTo(color: tintColor)
        imgView.clipsToBounds = true
        textField.leftView = nil
        
        textField.leftView = imgView
        textField.leftViewMode = .always
    }
    
    /// Set the Right view in textField
    ///
    /// - Parameters:
    ///   - image: UIimage For Left view
    ///   - textField: UITextField
    func setRightViewButtonForTextField(image: UIImage,textField: UITextField, tintColor: UIColor = #colorLiteral(red: 0.5058823529, green: 0.5058823529, blue: 0.5058823529, alpha: 1)) {
        
        let imgView = UIImageView(frame: CGRect(x: (textField.frame.size.width - 40), y: 0, width: 40, height: 45))
        imgView.contentMode = .center
        imgView.image = image
        imgView.changePngColorTo(color: tintColor)
        imgView.clipsToBounds = true
        textField.rightView = imgView
        textField.rightViewMode = .always
    }
    
    /// Navigation Bar Setup
    func setNavigationBar() {
        self.navigationController?.isNavigationBarHidden = false
        let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView
        statusBar?.tintColor = UIColor.white
        statusBar?.backgroundColor = #colorLiteral(red: 0.8524288535, green: 0.02872790955, blue: 0.1986387968, alpha: 1)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        self.navigationController?.navigationBar.backgroundColor = #colorLiteral(red: 0.8404900432, green: 0.02909317985, blue: 0.194884181, alpha: 1)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = #colorLiteral(red: 0.8524288535, green: 0.02872790955, blue: 0.1986387968, alpha: 1)
//        self.navigationItem.hidesBackButton = true
    }
    
    // get Navigationbar buttons
    public func getNavBarButtonWithText(titleText: String ,action : Selector, target : Any) -> UIBarButtonItem {
        let btnBar = UIButton(type: .custom)
        btnBar.setTitle(titleText, for: UIControl.State())
        btnBar.titleLabel?.font = UIFont(name: "Montserrat-Medium", size: 16)
        btnBar.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: UIControl.State())
        btnBar.contentHorizontalAlignment = .center
        btnBar.addTarget(target, action: action, for: .touchUpInside)
        btnBar.frame = CGRect(x: 0, y: 0, width: 25, height: 30)
        let barButton : UIBarButtonItem = UIBarButtonItem(customView: btnBar)
        return barButton
    }
    
    /// Navigation Bar Without StatusBar
    func setNavigationBarWithoutstatusBar() {
        self.navigationController?.isNavigationBarHidden = false
        //        let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView
        //        statusBar?.tintColor = UIColor.white
        //        statusBar?.backgroundColor = #colorLiteral(red: 0.8524288535, green: 0.02872790955, blue: 0.1986387968, alpha: 1)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        self.navigationController?.navigationBar.backgroundColor = #colorLiteral(red: 0.8404900432, green: 0.02909317985, blue: 0.194884181, alpha: 1)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = #colorLiteral(red: 0.8524288535, green: 0.02872790955, blue: 0.1986387968, alpha: 1)
//        self.navigationItem.hidesBackButton = true
    }
    
    /// Navigation Bar Without StatusBar
    func setNavigationBarClearBar() {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        self.navigationController?.navigationBar.backgroundColor = UIColor.clear
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
        self.navigationItem.hidesBackButton = true
    }
    
    /// Open Full view image
    ///
    /// - Parameters:
    ///   - arrImage: Array of image url
    ///   - currentImage: current image index
    func showImageDetailView(arrImage: [String], currentImage: Int = 0) {
        var images = [SKPhoto]()
        _ = arrImage.map {
            let photo = SKPhoto.photoWithImageURL($0)
            photo.shouldCachePhotoURLImage = true // you can use image cache by true(NSCache)
            images.append(photo)
        }
        
        let browser = SKPhotoBrowser(photos: images)
        browser.delegate = self
        SKPhotoBrowserOptions.displayAction = false
        browser.initializePageIndex(currentImage)
        present(browser, animated: true, completion: {})
    }
    
    
    func didShowPhotoAtIndex(_ index: Int) {
    }
    
    private func willDismissAtPageIndex(_ index: Int) {
    }
    
    private func willShowActionSheet(_ photoIndex: Int) {
    }
    
    private func didDismissAtPageIndex(_ index: Int) {
    }
    
    private func didDismissActionSheetWithButtonIndex(_ buttonIndex: Int, photoIndex: Int) {
    }
    
    private func removePhoto(_ browser: SKPhotoBrowser, index: Int, reload: @escaping (() -> Void)) {
        reload()
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        self.dismiss(animated: true, completion: nil)
    }
    
    /// Add shadow to button
    ///
    /// - Parameter button: UIButton
    func addButtonShadow(button: UIButton) {
        button.layer.cornerRadius = 5
        button.layer.shadowRadius = 3.0
        button.layer.shadowColor = UIColor.darkGray.cgColor
        button.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        button.layer.shadowOpacity = 0.5
        button.layer.masksToBounds = false
    }
    
    /// Add Goggle analytics
    ///
    /// - Parameters:
    ///   - analyticsParameterItemID: analyticsParameterItemID
    ///   - analyticsParameterItemName: analyticsParameterItemName
    ///   - analyticsParameterContentType: analyticsParameterContentType
    func addAnayltics(analyticsParameterItemID: String, analyticsParameterItemName: String,  analyticsParameterContentType: String) {
        Analytics.logEvent(AnalyticsEventSelectContent, parameters: [
            AnalyticsParameterItemID: analyticsParameterItemID,
            AnalyticsParameterItemName: analyticsParameterItemName,
            AnalyticsParameterContentType: analyticsParameterContentType
            ])
    }
}


