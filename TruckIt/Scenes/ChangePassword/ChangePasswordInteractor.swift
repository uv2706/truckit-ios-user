//
//  ChangePasswordInteractor.swift
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

protocol ChangePasswordBusinessLogic {
    func changePassword(request: ChangePassword.Request)
}

protocol ChangePasswordDataStore {
    
}

class ChangePasswordInteractor: ChangePasswordBusinessLogic, ChangePasswordDataStore {
    var presenter: ChangePasswordPresentationLogic?
    var worker: ChangePasswordWorker?
    
    func changePassword(request: ChangePassword.Request) {
        worker = ChangePasswordWorker()
        worker?.changePassword(request: request, completionHandler: { (message, success) in
            self.presenter?.presentChangePassword(message: message ?? "", success: success ?? "0")
        })
    }
}