//
//  ChangeMobileNumberInteractor.swift
//  PickUpDriver
//
//  Created by hb on 21/06/19.

import UIKit

protocol ChangeMobileNumberBusinessLogic {
    func getOtp(request: ChangeMobileNumber.Request)
}

protocol ChangeMobileNumberDataStore {
    
}

class ChangeMobileNumberInteractor: ChangeMobileNumberBusinessLogic, ChangeMobileNumberDataStore {
    var presenter: ChangeMobileNumberPresentationLogic?
    var worker: ChangeMobileNumberWorker?
    
    func getOtp(request: ChangeMobileNumber.Request) {
        worker = ChangeMobileNumberWorker()
        worker?.getOtp(request: request, completionHandler: { (response, message, success) in
            self.presenter?.presentOtp(response: response, message: message ?? "", success: success ?? "0")
        })
    }
    
}
