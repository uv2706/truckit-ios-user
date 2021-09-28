//
//  SideMenuInteractor.swift
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

protocol SideMenuBusinessLogic {
     func logout()
}

protocol SideMenuDataStore {
    
}

class SideMenuInteractor: SideMenuBusinessLogic, SideMenuDataStore {
    var presenter: SideMenuPresentationLogic?
    var worker: SideMenuWorker?
    
    func logout() {
        worker = SideMenuWorker()
        worker?.logout(completionHandler: { (message, success) in
            self.presenter?.presentLogout(message: message ?? "", success: success ?? "0" )
        })
    }
}