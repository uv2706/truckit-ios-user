//
//  EditProfilePresenter.swift
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

protocol EditProfilePresentationLogic {
    func presentEditProfile(response: Login.Authentication.ViewModel?, message: String, success: String)
}

class EditProfilePresenter: EditProfilePresentationLogic {
    weak var viewController: EditProfileDisplayLogic?
    
    func presentEditProfile(response: Login.Authentication.ViewModel?, message: String, success: String) {
        self.viewController?.didReceiveEditProfileResponse(response: response, message: message, success: success)
    }
}
