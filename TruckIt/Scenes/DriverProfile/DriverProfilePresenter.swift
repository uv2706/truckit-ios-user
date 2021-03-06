//
//  DriverProfilePresenter.swift
//  PickUpUser
//
//  Created by hb on 20/06/19.
//  Copyright (c) 2019 hb. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol DriverProfilePresentationLogic {
    func presentDriverDetail(response: DriverProfile.ViewModel?, message: String, success: String)
}

class DriverProfilePresenter: DriverProfilePresentationLogic {
    weak var viewController: DriverProfileDisplayLogic?
 
    func presentDriverDetail(response: DriverProfile.ViewModel?, message: String, success: String) {
        self.viewController?.didReceiveDriverDetail(response: response, message: message, success: success)
    }
}
