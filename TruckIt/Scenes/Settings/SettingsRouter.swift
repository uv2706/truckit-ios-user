//
//  SettingsRouter.swift
//  Udecide
//
//  Created by hb on 15/04/19.
//  Copyright (c) 2019 hb. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol SettingsRoutingLogic {
    func Logout()
    
}

protocol SettingsDataPassing {
    var dataStore: SettingsDataStore? { get set }
}

class SettingsRouter: NSObject, SettingsRoutingLogic, SettingsDataPassing {
    weak var viewController: SettingsViewController?
    var dataStore: SettingsDataStore?
 
    func Logout() {
        TruckItSessionHandler.shared.removeUserDefaultsWhileLoggedOut()
        if let loginVc = LoginViewController.instance() {
            let vc = NavController.init(rootViewController: loginVc)
            AppConstants.appDelegate.window?.rootViewController = vc
        }
    }
}