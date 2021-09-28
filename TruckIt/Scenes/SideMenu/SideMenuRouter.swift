//
//  SideMenuRouter.swift
//  AtlasGPS
//
//  Created by hb on 19/04/19.
//  Copyright (c) 2019 hb. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol SideMenuRoutingLogic {
    func Logout()
}

protocol SideMenuDataPassing {
    var dataStore: SideMenuDataStore? { get set }
}

class SideMenuRouter: NSObject, SideMenuRoutingLogic, SideMenuDataPassing {
    weak var viewController: SideMenuViewController?
    var dataStore: SideMenuDataStore?
    
    func Logout() {
        TruckItSessionHandler.shared.removeUserDefaultsWhileLoggedOut()
        
        if let login = LoginViewController.instance() {
            let vc = NavController.init(rootViewController: login)
            AppConstants.appDelegate.window?.rootViewController = vc
        }
    }
}
